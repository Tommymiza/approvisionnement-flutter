import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'current_event.dart';

class CurrentBloc extends Bloc<CurrentEvent, User?>{
  CurrentBloc() : super(null){
    on<UserConnected>((event, emit) async {
      emit(event.user);
    });
    on<UserDisconnected>((event, emit) {
      emit(null);
    });
  }
}