import 'package:approvisionnement/data/consumer/consumer_bloc.dart';
import 'package:approvisionnement/data/current/current_bloc.dart';
import 'package:approvisionnement/data/dialogloading/loading_dialog_bloc.dart';
import 'package:approvisionnement/data/foods/food_bloc.dart';
import 'package:approvisionnement/data/iconloading/loading_icon_bloc.dart';
import 'package:approvisionnement/data/loading/loading_bloc.dart';
import 'package:approvisionnement/data/providers/provider_bloc.dart';
import 'package:approvisionnement/data/redirect/redirect_bloc.dart';
import 'package:approvisionnement/tools/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CurrentBloc>(create: (context) => CurrentBloc()),
        BlocProvider<LoadingBloc>(create: (context) => LoadingBloc()),
        BlocProvider<LoadingDialogBloc>(create: (context) => LoadingDialogBloc()),
        BlocProvider<LoadingIconBloc>(create: (context) => LoadingIconBloc()),
        BlocProvider<RedirectBloc>(create: (context) => RedirectBloc()),
        BlocProvider<ProviderBloc>(create: (context) => ProviderBloc()),
        BlocProvider<FoodBloc>(create: (context) => FoodBloc()),
        BlocProvider<ConsumerBloc>(create: (context) => ConsumerBloc()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.lightGreen[50],
          primarySwatch: mycolor,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            selectedIconTheme: IconThemeData(
              size: 40,
            ),
            unselectedIconTheme: IconThemeData(
              color: Colors.black26,
              size: 30,
            ),
            selectedItemColor: Color.fromARGB(255, 109, 151, 136),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 17
            ),
          ),
          fontFamily: "Work Sans"
        ),
      ),
    ),
  );
}
