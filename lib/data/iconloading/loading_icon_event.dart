part of 'loading_icon_bloc.dart';

abstract class LoadingIconEvent{}

class SetLoadingIcon extends LoadingIconEvent{}
class ClearLoadingIcon extends LoadingIconEvent{}