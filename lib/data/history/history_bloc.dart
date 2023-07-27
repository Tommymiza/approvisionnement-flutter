import 'package:approvisionnement/models/history.dart';
import 'package:approvisionnement/services/history_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'history_event.dart';

class HistoryBloc extends Bloc<HistoryEvent, List<History>>{
  HistoryBloc() : super([]){
    on<GetHistory>((event, emit) async {
      emit(await HistoryService.getHistories());
    });
  }
}