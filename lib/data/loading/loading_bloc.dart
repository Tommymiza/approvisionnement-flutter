import 'package:flutter_bloc/flutter_bloc.dart';

part 'loading_event.dart';

class LoadingBloc extends Bloc<LoadingEvent, bool> {
  LoadingBloc() : super(false) {
    on<SetLoading>((event, emit) {
      emit(true);
    });
    on<ClearLoading>((event, emit) {
      emit(false);
    });
  }
}
