import 'package:approvisionnement/data/consumer/consumer_bloc.dart';
import 'package:approvisionnement/data/current/current_bloc.dart';
import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/data/providers/provider_bloc.dart';
import 'package:approvisionnement/data/redirect/redirect_bloc.dart';
import 'package:approvisionnement/pages/food.dart';
import 'package:approvisionnement/pages/history.dart';
import 'package:approvisionnement/pages/provider.dart';
import 'package:approvisionnement/pages/consumer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Struct extends StatefulWidget {
  const Struct({super.key});

  @override
  State<Struct> createState() => _StructState();
}

class _StructState extends State<Struct> {
  @override
  void initState() {
    context.read<ProviderBloc>().add(GetProvider());
    context.read<FoodBloc>().add(GetFood());
    context.read<ConsumerBloc>().add(GetConsumers());
    super.initState();
  }

  final List<Widget> pages = [
    const ProviderPage(),
    const Food(),
    const ConsumerPage(),
    const HistoryPage(),
  ];

  int page = 0;

  @override
  Widget build(BuildContext context) {
    String email =
        context.read<CurrentBloc>().state?.email ?? "tommymiza20@gmail.com";
    return BlocListener<CurrentBloc, User?>(
      listener: (context, state) {
        if (state != null) {
          context
              .read<RedirectBloc>()
              .add(RedirectWithUrl(url: '/', context: context));
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 30,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  email,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<CurrentBloc>().add(UserDisconnected());
                },
                child: Icon(
                  Icons.power_settings_new_rounded,
                  size: 30,
                  color: Colors.red[600],
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: pages[page],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart_rounded),
                label: "Provider"),
            BottomNavigationBarItem(
                icon: Icon(Icons.cookie_outlined),
                activeIcon: Icon(Icons.cookie_rounded),
                label: "Foods"),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                activeIcon: Icon(Icons.location_on_rounded),
                label: "Consumer"),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_history_outlined),
                activeIcon: Icon(Icons.location_history_rounded),
                label: "History"),
          ],
          currentIndex: page,
          onTap: (value) {
            setState(() {
              page = value;
            });
          },
        ),
      ),
    );
  }
}
