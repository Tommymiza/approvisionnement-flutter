import 'package:approvisionnement/models/prov.dart';
import 'package:approvisionnement/services/provider_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'provider_event.dart';

class ProviderBloc extends Bloc<ProviderEvent, List<Prov>>{
  ProviderBloc() : super([]){
    on<GetProvider>((event, emit) async {
      emit(await ProviderService.getProviders());
    });
  }
}