part of "loadingpage_bloc.dart";

abstract class LoadingPageEvent{}

class SetLoadingPage extends LoadingPageEvent{}
class ClearLoadingPage extends LoadingPageEvent{}