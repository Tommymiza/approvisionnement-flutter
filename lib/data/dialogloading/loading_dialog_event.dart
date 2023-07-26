part of 'loading_dialog_bloc.dart';

abstract class LoadingDialogEvent{}

class SetLoadingDialog extends LoadingDialogEvent{}
class ClearLoadingDialog extends LoadingDialogEvent{}