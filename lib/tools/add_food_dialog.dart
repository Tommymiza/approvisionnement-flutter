import 'dart:io';
import 'package:approvisionnement/data/dialogloading/loading_dialog_bloc.dart';
import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/services/food_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showAddFoodDialog(
  BuildContext context,
) async {
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.lightGreen[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AddFoodDialog(
        ctx: ctx,
      ),
    ),
  );
}

class AddFoodDialog extends StatefulWidget {
  final BuildContext ctx;
  const AddFoodDialog({super.key, required this.ctx});

  @override
  State<AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  File photo = File("");
  TextEditingController name = TextEditingController();
  TextEditingController descri = TextEditingController();
  TextEditingController unit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Food",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      final pickedFile = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          photo = File(pickedFile.path);
                        });
                      } else {
                        print('No image selected!');
                      }
                    },
                    icon: const Icon(Icons.image_rounded)),
                IconButton(
                    onPressed: () async {
                      final pickedFile = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      if (pickedFile != null) {
                        setState(() {
                          photo = File(pickedFile.path);
                        });
                      } else {
                        print('No image selected!');
                      }
                    },
                    icon: const Icon(Icons.camera_alt_rounded)),
              ],
            ),
            photo.path == ""
                ? const SizedBox()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      photo,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
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
                controller: unit,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Unit"),
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
                        if (name.text == "" ||
                            descri.text == "" ||
                            unit.text == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackbar("Field required! 😗"));
                          return;
                        }
                        if (photo.path == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackbar("Photo required! 😗"));
                          return;
                        }
                        context
                            .read<LoadingDialogBloc>()
                            .add(SetLoadingDialog());
                        FoodService.addFood(
                                name.text, descri.text, photo, unit.text)
                            .then((value) {
                          if (value != null) {
                            context.read<FoodBloc>().add(GetFood());
                            context
                                .read<LoadingDialogBloc>()
                                .add(ClearLoadingDialog());
                            Navigator.pop(widget.ctx);
                          } else {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(snackbar("Operation failed!"));
                            context
                                .read<LoadingDialogBloc>()
                                .add(ClearLoadingDialog());
                            Navigator.pop(widget.ctx);
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
                          const Icon(Icons.fastfood_rounded),
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
    );
  }
}
