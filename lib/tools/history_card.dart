import 'package:approvisionnement/models/history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final History h;
  const HistoryCard({super.key, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${DateFormat("dd MMMM yyyy HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(int.parse((h.date.seconds * 1000).toString())))}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "By: ${h.email}",
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: h.type,
                    style: const TextStyle(color: Colors.black, fontSize: 17)),
                const TextSpan(
                    text: " of ",
                    style: TextStyle(color: Colors.black, fontSize: 17)),
                TextSpan(
                  text: "${h.product} ",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                TextSpan(
                    text: "${h.quantity} ",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17)),
                TextSpan(
                    text: h.type == "Stock entry" ? "from " : "for ",
                    style: const TextStyle(color: Colors.black, fontSize: 17)),
                TextSpan(
                    text: h.actor,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17))
              ])),
            ),
          ],
        ));
  }
}
