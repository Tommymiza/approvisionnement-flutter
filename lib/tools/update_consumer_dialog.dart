import 'package:approvisionnement/data/consumer/consumer_bloc.dart';
import 'package:approvisionnement/data/dialogloading/loading_dialog_bloc.dart';
import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/models/consumer.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/services/consumer_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> showUpdateConsumerDialog(BuildContext context, Consumer c) async {
  return showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
            backgroundColor: Colors.lightGreen[50],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ConsumerUpdateDialog(
              ctx: ctx,
              c: c
            ),
          ));
}

class ConsumerUpdateDialog extends StatefulWidget {
  final BuildContext ctx;
  final Consumer c;
  const ConsumerUpdateDialog({super.key, required this.ctx, required this.c});
  @override
  State<ConsumerUpdateDialog> createState() => _ConsumerUpdateDialogState();
}

class _ConsumerUpdateDialogState extends State<ConsumerUpdateDialog> {
  @override
  void initState() {
    name.text = widget.c.name;
    phone.text = widget.c.phone;
    email.text = widget.c.email;
    super.initState();
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List champs = List.from(context.read<FoodBloc>().state.map((e) =>
        {"name": e.name, "controller": TextEditingController(text: "")}));
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Update Consumer",
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
              child: TextFormField(
                controller: name,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Name"),
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
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Email"),
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
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: phone,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Phone"),
              ),
            ),
            const Text(
              "Foods:",
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: champs
                  .map((e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(e["name"])),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
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
                              controller: e["controller"],
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                  border: InputBorder.none, hintText: "Stock"),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
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
                        if (name.text == "" ||
                            email.text == "" ||
                            phone.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(snackbar(
                              "Field 'name', 'email', 'phone' are required!"));
                          return;
                        }
                        context
                            .read<LoadingDialogBloc>()
                            .add(SetLoadingDialog());
                        List<FoodState> foods = context.read<FoodBloc>().state;
                        List consommation = List.from(champs.map((e) {
                          if (e["controller"].text == "") {
                            return null;
                          }
                          List f = List.from(foods);
                          f.removeWhere((element) => element.name != e["name"]);
                          return {
                            "name": e["name"],
                            "stock": "${e["controller"].text} ${f[0].unit}"
                          };
                        }));
                        consommation.removeWhere((element) => element == null);
                        ConsumerService.updateConsumer(widget.c.id, name.text, email.text,
                                phone.text, consommation)
                            .then((value) {
                          if (value != null) {
                            context
                                .read<LoadingDialogBloc>()
                                .add(ClearLoadingDialog());
                            context.read<FoodBloc>().add(GetFood());
                            context.read<ConsumerBloc>().add(GetConsumers());
                            Navigator.pop(widget.ctx);
                          } else {
                            context
                                .read<LoadingDialogBloc>()
                                .add(ClearLoadingDialog());
                          }
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
                          const Icon(Icons.edit_rounded),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Update",
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
