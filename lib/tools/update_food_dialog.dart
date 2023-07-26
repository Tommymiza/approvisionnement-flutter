import 'package:approvisionnement/data/dialogloading/loading_dialog_bloc.dart';
import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/services/food_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> showUpdateFoodDialog(BuildContext context, FoodState f) async {
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.lightGreen[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: UpdateFoodDialog(
        ctx: ctx,
        f: f,
      ),
    ),
  );
}

class UpdateFoodDialog extends StatefulWidget {
  final FoodState f;
  final BuildContext ctx;
  const UpdateFoodDialog({super.key, required this.f, required this.ctx});

  @override
  State<UpdateFoodDialog> createState() => _UpdateFoodDialogState();
}

class _UpdateFoodDialogState extends State<UpdateFoodDialog> {
  @override
  void initState() {
    name.text = widget.f.name;
    descri.text = widget.f.descri;
    super.initState();
  }

  TextEditingController name = TextEditingController();
  TextEditingController descri = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Update Food",
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
                controller: descri,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Description"),
              ),
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
                        if (name.text == "" || descri.text == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackbar("Field required! 😗"));
                          return;
                        }
                        context
                            .read<LoadingDialogBloc>()
                            .add(SetLoadingDialog());
                        FoodService.updateFood(widget.f.id, name.text,
                                descri.text, widget.f.stock)
                            .then((value) {
                          if (value != null) {
                            context.read<FoodBloc>().add(GetFood());
                            context
                                .read<LoadingDialogBloc>()
                                .add(ClearLoadingDialog());
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar("Update finished! 🤩"));
                            Navigator.pop(widget.ctx);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar("Update failed! 😭"));
                            Navigator.pop(widget.ctx);
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
                            "Edit",
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
