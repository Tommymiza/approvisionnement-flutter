import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/data/iconloading/loading_icon_bloc.dart';
import 'package:approvisionnement/data/loading/loading_bloc.dart';
import 'package:approvisionnement/data/providers/provider_bloc.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/models/prov.dart';
import 'package:approvisionnement/services/food_service.dart';
import 'package:approvisionnement/services/provider_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:approvisionnement/tools/update_provider_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OneProvider extends StatefulWidget {
  final String id;
  const OneProvider({super.key, required this.id});

  @override
  State<OneProvider> createState() => _OneProviderState();
}

class _OneProviderState extends State<OneProvider> {
  TextEditingController quantity = TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<FoodBloc, List<FoodState>>(
      builder: (context, st) {
        return BlocBuilder<ProviderBloc, List<Prov>>(
          builder: (context, state) {
            List<Prov> provs = List.from(state);
            provs.removeWhere((element) => element.id != widget.id);
            Prov p = provs[0];
            List<FoodState> foods = List.from(st);
            foods.retainWhere((element) => element.name == p.product);
            FoodState? f = foods.isNotEmpty ? foods[0] : null;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: p.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SpinKitCircle(
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.wifi_tethering_error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                  fontFamily: "Gumela",
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () => showUpdateProviderDialog(
                                        context, p),
                                    icon: const Icon(Icons.edit_square)),
                                BlocBuilder<LoadingIconBloc, bool>(
                                  builder: (context, state) {
                                    return IconButton(
                                        onPressed: state
                                            ? () {}
                                            : () {
                                                context
                                                    .read<LoadingIconBloc>()
                                                    .add(SetLoadingIcon());
                                                ProviderService.deleteProvider(
                                                        p.id)
                                                    .then((value) {
                                                  if (value != null) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackbar(
                                                            "Delete finished! 🤩"));
                                                    context
                                                        .read<ProviderBloc>()
                                                        .add(GetProvider());
                                                    Navigator.pop(context);
                                                    context
                                                        .read<LoadingIconBloc>()
                                                        .add(
                                                            ClearLoadingIcon());
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackbar(
                                                            "Delete failed! 😭"));
                                                    context
                                                        .read<LoadingIconBloc>()
                                                        .add(
                                                            ClearLoadingIcon());
                                                  }
                                                });
                                              },
                                        icon: state
                                            ? const SpinKitCircle(
                                                color: Colors.black,
                                                size: 15,
                                              )
                                            : const Icon(Icons.delete_rounded));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          p.descri,
                          style: const TextStyle(
                              fontFamily: "Work Sans",
                              fontSize: 20,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${p.product} :",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 226, 226, 226),
                                        blurRadius: 5.0, // soften the shadow
                                        spreadRadius: 0.0, //extend the shadow
                                        offset: Offset(
                                          0, // Move to right 5  horizontally
                                          0, // Move to bottom 5 Vertically
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: quantity,
                                    onChanged: (value) {
                                      setState(() {
                                        error = "";
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Quantity"),
                                  ),
                                ),
                                BlocBuilder<LoadingBloc, bool>(
                                  builder: (context, state) => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 17),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    onPressed: state
                                        ? () {}
                                        : () {
                                            int? value =
                                                int.tryParse(quantity.text);
                                            if (value == null) {
                                              setState(() {
                                                error =
                                                    "Input value is not valid! 😭";
                                              });
                                              return;
                                            }
                                            if (f != null) {
                                              context
                                                  .read<LoadingBloc>()
                                                  .add(SetLoading());
                                              FoodService.updateFood(
                                                      f.id,
                                                      f.name,
                                                      f.descri,
                                                      f.stock + value)
                                                  .then((res) {
                                                context
                                                    .read<LoadingBloc>()
                                                    .add(ClearLoading());
                                                if (res != null) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackbar(
                                                          "$value ${f.unit} of \"${f.name}\" has been added! 🤗"));
                                                  context
                                                      .read<FoodBloc>()
                                                      .add(GetFood());
                                                  return;
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackbar(
                                                        "Operation failed! 😭"));
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar(
                                                      "This food is not avaible for you 🥹"));
                                            }
                                          },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: state
                                          ? <Widget>[
                                              const SpinKitCircle(
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ]
                                          : <Widget>[
                                              const Icon(Icons
                                                  .add_shopping_cart_rounded),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Text(
                                                "Add",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  error,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 228, 27, 13)),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    ));
  }
}
