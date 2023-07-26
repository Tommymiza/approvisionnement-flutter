import 'package:approvisionnement/models/food_state.dart';
import 'package:approvisionnement/services/food_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_event.dart';

class FoodBloc extends Bloc<FoodEvent, List<FoodState>>{
  FoodBloc() : super([]){
    on<GetFood>((event, emit) async {
      emit(await FoodService.getFoods());
    });
  }
}