import 'package:flutter_bloc/flutter_bloc.dart';

part 'loading_dialog_event.dart';

class LoadingDialogBloc extends Bloc<LoadingDialogEvent, bool> {
  LoadingDialogBloc() : super(false) {
    on<SetLoadingDialog>((event, emit) {
      emit(true);
    });
    on<ClearLoadingDialog>((event, emit) {
      emit(false);
    });
  }
}
