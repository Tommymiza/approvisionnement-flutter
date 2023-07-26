import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'redirect_event.dart';

class RedirectBloc extends Bloc<RedirectEvent, void>{
  RedirectBloc() : super(null){
    on<RedirectWithUrl>((event, emit) {
      event.context.go(event.url);
    });
  }
}