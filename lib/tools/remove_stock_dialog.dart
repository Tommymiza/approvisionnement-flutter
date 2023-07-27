import 'package:approvisionnement/data/current/current_bloc.dart';
import 'package:approvisionnement/data/dialogloading/loading_dialog_bloc.dart';
import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/data/history/history_bloc.dart';
import 'package:approvisionnement/models/consumer.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/services/food_service.dart';
import 'package:approvisionnement/services/history_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> showRemoveStockDialog(
  BuildContext context, Consumer c
) async {
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.lightGreen[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: RemoveStock(
        ctx: ctx,
        c: c
      ),
    ),
  );
}

class RemoveStock extends StatefulWidget {
  final BuildContext ctx;
  final Consumer c;
  const RemoveStock({super.key, required this.ctx, required this.c});

  @override
  State<RemoveStock> createState() => _RemoveStockState();
}

class _RemoveStockState extends State<RemoveStock> {
  TextEditingController quantity = TextEditingController();
  String? product = "Rice";
  @override
  Widget build(BuildContext context) {
    List<FoodState> foods = context.read<FoodBloc>().state;
    List<String> f = foods.map((e) => e.name).toList();
    String email = context.read<CurrentBloc>().state!.email!;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Send food",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
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
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                hint: const Text("Product"),
                value: "Rice",
                items: f
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    product = value;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
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
              child: TextFormField(
                controller: quantity,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Quantity"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<LoadingDialogBloc, bool>(
              builder: (context, state) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: state
                    ? () {}
                    : () async {
                        if (quantity.text == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackbar("Field required! 😗"));
                          return;
                        }
                        
                        List<FoodState> fs = List.from(context.read<FoodBloc>().state);
                        fs.removeWhere((element) => element.name != product);
                        if(int.parse(quantity.text) > fs[0].stock){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackbar("Out of stock! 😭"));
                          return;
                        }
                        context
                            .read<LoadingDialogBloc>()
                            .add(SetLoadingDialog());
                        FoodService.updateFood(
                                  fs[0].id, fs[0].name, fs[0].descri, fs[0].stock - int.parse(quantity.text))
                              .then((res) {
                            HistoryService.addHistories(email, widget.c.name, product!,
                                    "${quantity.text} ${fs[0].unit}", "Out of stock")
                                .then((res) {
                              if (res != null) {
                                widget.ctx.read<HistoryBloc>().add(GetHistory());
                                widget.ctx
                                    .read<LoadingDialogBloc>()
                                    .add(ClearLoadingDialog());
                                ScaffoldMessenger.of(context).showSnackBar(snackbar(
                                    "${quantity.text} ${fs[0].unit} of \"${fs[0].name}\" has been sent to ${widget.c.name}! 🤗"));
                                widget.ctx.read<FoodBloc>().add(GetFood());
                                Navigator.pop(widget.ctx);
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackbar("Operation failed! 😭"));
                              Navigator.pop(widget.ctx);
                            });
                          });
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: state
                      ? <Widget>[
                          const SpinKitCircle(
                            color: Colors.white,
                            size: 25,
                          ),
                        ]
                      : <Widget>[
                          const Icon(Icons.add_card_rounded),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Send",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
