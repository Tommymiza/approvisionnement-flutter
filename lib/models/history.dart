import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String id;
  final String actor;
  final String email;
  final String type;
  final String product;
  final String quantity;
  final Timestamp date;

  History({required this.actor, required this.date, required this.email, required this.product, required this.quantity, required this.type, required this.id});
  static History fromJson(e, id) {
    return History(actor: e["actor"], date: e["date"], email: e["email"], product: e["product"], quantity: e["quantity"], type: e["type"], id: id);
  }
}