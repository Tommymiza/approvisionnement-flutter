import 'package:approvisionnement/data/dialogloading/loading_dialog_bloc.dart';
import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/services/food_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> showAddStockDialog(
    BuildContext context, FoodState f, TextEditingController quantity) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.lightGreen[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add to Stock",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Quatity"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<LoadingDialogBloc, bool>(
                builder: (ctx, state) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 17),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: state
                      ? () {}
                      : () {
                          int? value = int.tryParse(quantity.text);
                          if (value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackbar("Input value is not valid! 😭"));
                            return;
                          }
                          ctx.read<LoadingDialogBloc>().add(SetLoadingDialog());
                          FoodService.updateFood(
                                  f.id, f.name, f.descri, f.stock + value)
                              .then((res) {
                            ctx
                                .read<LoadingDialogBloc>()
                                .add(ClearLoadingDialog());
                            if (res != null) {
                              ScaffoldMessenger.of(context).showSnackBar(snackbar(
                                  "$value ${f.unit} of \"${f.name}\" has been added! 🤗"));
                              ctx.read<FoodBloc>().add(GetFood());
                              Navigator.pop(context);
                              return;
                            }
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar("Operation failed! 😭"));
                            Navigator.pop(context);
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
                            const Icon(Icons.add_shopping_cart_rounded),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
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
            ],
          ),
        ),
      ),
    ),
  );
}
