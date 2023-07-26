import 'package:cloud_firestore/cloud_firestore.dart';

class Prov {
  final String id;
  final String name;
  final String image;
  final String descri;
  final String product;
  final Timestamp created;

  Prov(
      {required this.id,
      required this.name,
      required this.image,
      required this.descri,
      required this.product,
      required this.created});

  static Prov fromJson(e, id) {
    return Prov(
        id: id,
        created: e["created"],
        descri: e["descri"],
        image: e["image"],
        name: e["name"],
        product: e["product"]);
  }
}
