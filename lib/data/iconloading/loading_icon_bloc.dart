import 'package:flutter_bloc/flutter_bloc.dart';

part 'loading_icon_event.dart';

class LoadingIconBloc extends Bloc<LoadingIconEvent, bool> {
  LoadingIconBloc() : super(false) {
    on<SetLoadingIcon>((event, emit) {
      emit(true);
    });
    on<ClearLoadingIcon>((event, emit) {
      emit(false);
    });
  }
}
