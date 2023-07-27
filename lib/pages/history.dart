import 'package:approvisionnement/data/history/history_bloc.dart';
import 'package:approvisionnement/models/history.dart';
import 'package:approvisionnement/tools/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  String search = "";

  List<HistoryCard> checkSearchWithoutChip(providers) {
    List<HistoryCard> l = [];
    for (History p in providers) {
      if (p.email.toLowerCase().contains(search.toLowerCase())) {
        l.add(HistoryCard(h: p));
      }
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, List<History>>(
      builder: (context, state) {
        state.sort((a, b) => b.date.compareTo(a.date));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      "All History",
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
                    ? state.map((e) => HistoryCard(h: e)).toList()
                    : checkSearchWithoutChip(state),
              ),
            )
          ],
        );
      },
    );
  }
}