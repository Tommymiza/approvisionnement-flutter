import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/data/providers/provider_bloc.dart';
import 'package:approvisionnement/models/prov.dart';
import 'package:approvisionnement/tools/add_provider_dialog.dart';
import 'package:approvisionnement/tools/chip.dart';
import 'package:approvisionnement/tools/provider_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  @override
  void initState() {
    super.initState();
  }

  List<dynamic> chips = [];

  String search = "";

  List<ProvCard> checkList(providers) {
    List<ProvCard> l = [];
    for (Prov p in providers) {
      for (Map a in chips) {
        if (a["name"] == p.product && a["selected"]) {
          l.add(ProvCard(p: p));
        }
      }
    }
    return l;
  }

  List<ProvCard> checkSearchWithChip(providers) {
    List<ProvCard> l = [];
    for (Prov p in providers) {
      for (Map a in chips) {
        if (a["name"] == p.product &&
            a["selected"] &&
            p.name.toLowerCase().contains(search.toLowerCase())) {
          l.add(ProvCard(p: p));
        }
      }
    }
    return l;
  }

  List<ProvCard> checkSearchWithoutChip(providers) {
    List<ProvCard> l = [];
    for (Prov p in providers) {
      if (p.name.toLowerCase().contains(search.toLowerCase())) {
        l.add(ProvCard(p: p));
      }
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FoodBloc>().state.forEach((e) {
      if (chips.every((element) => element["name"] != e.name)) {
        setState(() {
          chips.add({"name": e.name, "selected": false});
        });
      }
    });
    return BlocBuilder<ProviderBloc, List<Prov>>(
      builder: (context, state) {
        List<Prov> lastest = List.from(state);
        lastest.sort((a, b) => a.created.compareTo(b.created));
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
                onPressed: () => showAddProviderDialog(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_card_rounded),
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
            search == ""
                ? Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Text(
                      "Latest provider",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ))
                : const SizedBox(),
            search == ""
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                    child: SizedBox(
                      height: 320,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        children: lastest.reversed
                            .map((e) => ProvCard(p: e))
                            .toList(),
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
                margin: const EdgeInsets.only(left: 30, top: 30),
                child: search == ""
                    ? const Text(
                        "All provider",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      )
                    : const Text(
                        "Search result...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  children: chips
                      .map((e) => ChipCustom(
                            prod: e["name"],
                            isSelected: e["selected"],
                            tap: () {
                              setState(() {
                                for (Map a in chips) {
                                  if (a["name"] != e["name"]) {
                                    a["selected"] = false;
                                  } else {
                                    a["selected"] = !a["selected"];
                                  }
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
              child: SizedBox(
                height: 320,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  children: search == ""
                      ? chips.every((element) => !element["selected"])
                          ? state.map((e) => ProvCard(p: e)).toList()
                          : checkList(state)
                      : chips.every((element) => !element["selected"])
                          ? checkSearchWithoutChip(state)
                          : checkSearchWithChip(state),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
