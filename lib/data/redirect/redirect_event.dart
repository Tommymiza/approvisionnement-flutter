part of 'redirect_bloc.dart';

abstract class RedirectEvent{}

class RedirectWithUrl extends RedirectEvent{
  final String url;
  final BuildContext context;
  RedirectWithUrl({required this.url, required this.context});
}