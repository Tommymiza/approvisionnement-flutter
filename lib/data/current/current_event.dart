part of 'current_bloc.dart';

abstract class CurrentEvent{}

class UserConnected extends CurrentEvent{
  final User user; 
  UserConnected({required this.user});
}
class UserDisconnected extends CurrentEvent{}