import 'package:approvisionnement/models/consumer.dart';
import 'package:approvisionnement/tools/remove_stock_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsumerCard extends StatelessWidget {
  final Consumer c;
  const ConsumerCard({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed("consumer", extra: c.id),
      child: Container(
        width: 340,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        padding:
            const EdgeInsets.only(top: 10, right: 20, bottom: 10, left: 10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                  imageUrl: c.image,
                  height: 100,
                  width: 100,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  c.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(1),
                      shape: MaterialStatePropertyAll(CircleBorder(
                          side: BorderSide.none, eccentricity: 0.05))),
                  child: const Icon(Icons.add_shopping_cart_rounded),
                  onPressed: () {
                    showRemoveStockDialog(context, c);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
