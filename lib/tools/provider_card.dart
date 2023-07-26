import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/models/prov.dart';
import 'package:approvisionnement/tools/add_stock_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ProvCard extends StatelessWidget {
  final Prov p;
  const ProvCard({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    TextEditingController quantity = TextEditingController();
    return GestureDetector(
      onTap: () {
        context.pushNamed("provider", extra: p.id);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        width: 200,
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 226, 226, 226),
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: Offset(
                        0, // Move to right 5  horizontally
                        0, // Move to bottom 5 Vertically
                      ),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: p.image,
                    height: 150,
                    width: 180,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Gumela"),
                        ),
                        Text(
                          p.descri.length > 45
                              ? '${p.descri.substring(0, 45)}...'
                              : p.descri,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            p.product,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                        BlocBuilder<FoodBloc, List<FoodState>>(
                          builder: (context, state) {
                            List<FoodState> foods = List.from(state);
                            foods.retainWhere(
                                (element) => element.name == p.product);
                            FoodState? f = foods.isNotEmpty ? foods[0] : null;
                            return f != null
                                ? ElevatedButton(
                                    style: const ButtonStyle(
                                        elevation: MaterialStatePropertyAll(1),
                                        shape: MaterialStatePropertyAll(
                                            CircleBorder(
                                                side: BorderSide.none,
                                                eccentricity: 0.1))),
                                    child: const Icon(
                                        Icons.add_shopping_cart_rounded),
                                    onPressed: () {
                                      showAddStockDialog(context, f, quantity);
                                    },
                                  )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
