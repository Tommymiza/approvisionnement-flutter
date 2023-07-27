
import 'package:flutter_bloc/flutter_bloc.dart';
part 'loadingpage_event.dart';

class LoadingPageBloc extends Bloc<LoadingPageEvent, bool>{
  LoadingPageBloc() : super(true){
    on<SetLoadingPage>((event, emit) => emit(true));
    on<ClearLoadingPage>((event, emit) => emit(false));
  }
}