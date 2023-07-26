import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/tools/add_food_dialog.dart';
import 'package:approvisionnement/tools/food_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  String search = "";
  List<FoodCard> checkSearchWithoutChip(providers) {
    List<FoodCard> l = [];
    for (FoodState p in providers) {
      if (p.name.toLowerCase().contains(search.toLowerCase())) {
        l.add(FoodCard(f: p));
      }
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, List<FoodState>>(
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
                onPressed: () => showAddFoodDialog(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.fastfood_rounded),
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
                      "All food",
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
                    ? state.map((e) => FoodCard(f: e)).toList()
                    : checkSearchWithoutChip(state),
              ),
            )
          ],
        );
      },
    );
  }
}
