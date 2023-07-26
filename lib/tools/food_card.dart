import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/data/iconloading/loading_icon_bloc.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/services/food_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:approvisionnement/tools/update_food_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FoodCard extends StatelessWidget {
  final FoodState f;
  const FoodCard({super.key, required this.f});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(colors: [
          Colors.white,
          Colors.lightGreen[50]!,
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 226, 226, 226),
            blurRadius: 5.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              0, // Move to right 5  horizontally
              0, // Move to bottom 5 Vertically
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 340,
            height: 250,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 233, 233, 233),
                  blurRadius: 20.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(
                    0,
                    10,
                  ),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: f.image,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      f.name,
                      style: const TextStyle(
                          fontFamily: "Gumela",
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => showUpdateFoodDialog(context, f),
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
                                        FoodService.deleteFood(f.id)
                                            .then((value) {
                                          if (value != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackbar(
                                                    "Delete finished! 🤩"));
                                            context
                                                .read<FoodBloc>()
                                                .add(GetFood());
                                            context
                                                .read<LoadingIconBloc>()
                                                .add(ClearLoadingIcon());
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackbar(
                                                    "Delete failed! 😭"));
                                            context
                                                .read<LoadingIconBloc>()
                                                .add(ClearLoadingIcon());
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
                  f.descri,
                  style: const TextStyle(
                      fontFamily: "Work Sans",
                      fontSize: 20,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.cyan[700],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Stock: ${f.stock} ${f.unit}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
