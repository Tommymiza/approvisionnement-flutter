import 'package:approvisionnement/data/dialogloading/loading_dialog_bloc.dart';
import 'package:approvisionnement/data/providers/provider_bloc.dart';
import 'package:approvisionnement/models/prov.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:approvisionnement/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> showUpdateProviderDialog(BuildContext context, Prov p) async {
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.lightGreen[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: UpdateProviderDialog(
        ctx: ctx,
        p: p,
      ),
    ),
  );
}

class UpdateProviderDialog extends StatefulWidget {
  final BuildContext ctx;
  final Prov p;
  const UpdateProviderDialog({super.key, required this.ctx, required this.p});

  @override
  State<UpdateProviderDialog> createState() => _UpdateProviderDialogState();
}

class _UpdateProviderDialogState extends State<UpdateProviderDialog> {
  @override
  void initState() {
    name.text = widget.p.name;
    descri.text = widget.p.descri;
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
              "Update Provider",
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
                        ProviderService.updateProvider(
                                widget.p.id, name.text, descri.text)
                            .then((value) {
                          if (value != null) {
                            context.read<ProviderBloc>().add(GetProvider());
                            context
                                .read<LoadingDialogBloc>()
                                .add(ClearLoadingDialog());
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar("Update finished! 🤩"));
                            Navigator.pop(widget.ctx);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar("Update failed! 😭"));
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
