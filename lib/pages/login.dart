import 'package:approvisionnement/data/current/current_bloc.dart';
import 'package:approvisionnement/data/loading/loading_bloc.dart';
import 'package:approvisionnement/data/redirect/redirect_bloc.dart';
import 'package:approvisionnement/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    if (context.read<CurrentBloc>().state != null) {
      context
          .read<RedirectBloc>()
          .add(RedirectWithUrl(url: "/appro", context: context));
    }
    super.initState();
  }

  bool showPassword = true;
  String error = "";
  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: InkWell(
          splashColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: BlocListener<CurrentBloc, User?>(
              listener: (context, state) {
                if (state != null) {
                  context
                      .read<RedirectBloc>()
                      .add(RedirectWithUrl(url: "/appro", context: context));
                }
                context.read<LoadingBloc>().add(ClearLoading());
              },
              child: Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/login.jpg",
                    width: 300,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 238, 234, 234)),
                    child: TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          icon: Icon(Icons.email_rounded)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 238, 234, 234)),
                    child: TextFormField(
                      controller: password,
                      obscureText: showPassword,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          icon: const Icon(Icons.password_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: Icon(showPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    error,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 228, 27, 13)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<LoadingBloc, bool>(
                    builder: (context, state) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 17),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: state
                          ? () {}
                          : () {
                              if (email.text.isEmpty || password.text.isEmpty) {
                                setState(() {
                                  error = "Champ obligatoire! 🙄";
                                });
                                return;
                              }
                              if (!email.text.contains("@") ||
                                  !email.text.contains(".")) {
                                setState(() {
                                  error = "Email invalide! 🫠";
                                });
                                return;
                              }
                              context.read<LoadingBloc>().add(SetLoading());
                              Auth.loginUser(email.text, password.text)
                                  .then((value) {
                                if (value != null) {
                                  context
                                      .read<CurrentBloc>()
                                      .add(UserConnected(user: value));
                                } else {
                                  setState(() {
                                    error = "Information invalide! 🥲";
                                  });
                                }
                                context.read<LoadingBloc>().add(ClearLoading());
                              }).catchError((err) {
                                print('Error: $err');
                                context.read<LoadingBloc>().add(ClearLoading());
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
                                const Icon(Icons.login_rounded),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Auth.loginWithGoogle().then((value) {
                        if (value != null) {
                          context
                              .read<CurrentBloc>()
                              .add(UserConnected(user: value));
                        } else {
                          setState(() {
                            error = "Utilisateur invalide! 🥲";
                          });
                        }
                      }).catchError((err) {
                        print('Error: $err');
                      });
                    },
                    child: Image.asset("assets/Google-Logo.png", width: 50,),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
