import 'package:approvisionnement/data/consumer/consumer_bloc.dart';
import 'package:approvisionnement/data/iconloading/loading_icon_bloc.dart';
import 'package:approvisionnement/models/consumer.dart';
import 'package:approvisionnement/services/consumer_service.dart';
import 'package:approvisionnement/tools/snackbar.dart';
import 'package:approvisionnement/tools/update_consumer_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class OneConsumer extends StatefulWidget {
  final String id;
  const OneConsumer({super.key, required this.id});

  @override
  State<OneConsumer> createState() => _OneConsumerState();
}

class _OneConsumerState extends State<OneConsumer> {
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ConsumerBloc, List<Consumer>>(
      builder: (context, state) {
        List<Consumer> provs = List.from(state);
        provs.removeWhere((element) => element.id != widget.id);
        Consumer p = provs[0];
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: p.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                    size: 25,
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.wifi_tethering_error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                              fontFamily: "Gumela",
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    showUpdateConsumerDialog(context, p),
                                icon: const Icon(Icons.edit_square)),
                            BlocBuilder<LoadingIconBloc, bool>(
                              builder: (context, state) {
                                return IconButton(
                                    onPressed: state
                                        ? () {}
                                        : () {
                                            context
                                                .read<LoadingIconBloc>()
                                                .add(SetLoadingIcon());
                                            ConsumerService.deleteConsumer(p.id)
                                                .then((value) {
                                              if (value != null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackbar(
                                                        "Delete finished! 🤩"));
                                                context
                                                    .read<LoadingIconBloc>()
                                                    .add(ClearLoadingIcon());
                                                context
                                                    .read<ConsumerBloc>()
                                                    .add(GetConsumers());
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackbar(
                                                        "Delete failed! 😭"));
                                                context
                                                    .read<LoadingIconBloc>()
                                                    .add(ClearLoadingIcon());
                                              }
                                              Navigator.pop(context);
                                            });
                                          },
                                    icon: state
                                        ? const SpinKitCircle(
                                            color: Colors.black,
                                            size: 15,
                                          )
                                        : const Icon(Icons.delete_rounded));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Monthly consumption:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Product",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                          Text("Stock",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    Column(
                      children: p.consommation
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e["name"]),
                                    Text(e["stock"]),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Contact:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        GestureDetector(
                          onTap: () async {
                            final Uri email = Uri.parse('mailto:${p.email}');
                            await launchUrl(email);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.email_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                p.email,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final Uri phone = Uri.parse('tel:${p.phone}');
                            await launchUrl(phone);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                p.phone,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
