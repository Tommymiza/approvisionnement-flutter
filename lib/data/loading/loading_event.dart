part of 'loading_bloc.dart';

abstract class LoadingEvent{}

class SetLoading extends LoadingEvent{}
class ClearLoading extends LoadingEvent{}