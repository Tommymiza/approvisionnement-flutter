import 'package:approvisionnement/models/consumer.dart';
import 'package:approvisionnement/services/consumer_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'consumer_event.dart';

class ConsumerBloc extends Bloc<ConsumerEvent, List<Consumer>> {
  ConsumerBloc() : super([]) {
    on<GetConsumers>((event, emit) async {
      emit(await ConsumerService.getConsumers());
    });
  }
}
