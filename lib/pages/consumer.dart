import 'package:approvisionnement/data/consumer/consumer_bloc.dart';
import 'package:approvisionnement/models/consumer.dart';
import 'package:approvisionnement/tools/add_consumer_dialog.dart';
import 'package:approvisionnement/tools/consumer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsumerPage extends StatefulWidget {
  const ConsumerPage({super.key});

  @override
  State<ConsumerPage> createState() => _ConsumerPageState();
}

class _ConsumerPageState extends State<ConsumerPage> {
  String search = "";
  List<ConsumerCard> checkSearchWithoutChip(providers) {
    List<ConsumerCard> l = [];
    for (Consumer p in providers) {
      if (p.name.toLowerCase().contains(search.toLowerCase())) {
        l.add(ConsumerCard(c: p));
      }
    }
    return l;
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerBloc, List<Consumer>>(
      builder: (context, state) {
        state.sort(
          (a, b) => a.name.compareTo(b.name),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => showAddConsumerDialog(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_location_alt_rounded),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
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
            Container(
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
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
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              search = "";
                            });
                          },
                          icon: const Icon(Icons.refresh_rounded)),
                      hintText: "Search"),
                )),
            Container(
              margin: const EdgeInsets.only(left: 30, top: 0, bottom: 30),
              child: search == ""
                  ? const Text(
                      "All consumer",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )
                  : const Text(
                      "Search result...",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
            ),
            Center(
              child: Column(
                children: search == ""
                    ? state.map((e) => ConsumerCard(c: e)).toList()
                    : checkSearchWithoutChip(state),
              ),
            )
          ],
        );
      },
    );
  }
}