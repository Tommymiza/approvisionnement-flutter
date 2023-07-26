import 'dart:io';
import 'package:approvisionnement/models/consumer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ConsumerService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<Consumer>> getConsumers() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("consumers").get();
      List<Consumer> consumers;
      if (snapshot.docs.isNotEmpty) {
        consumers = snapshot.docs
            .map((e) => Consumer.fromJson(e.data(), e.id))
            .toList();
        return consumers;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<String?> updateConsumer(
      String id, String name,String email,String phone, List consommation) async {
    try {
      DocumentReference consumerRef = firestore.collection("consumers").doc(id);
      await consumerRef.update({"name": name, "email": email, "phone": phone, "consommation": consommation});
      return "success";
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addConsumer(
      String name, String email, String phone, List foods, File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      final fileName = basename(image.path);
      await storage.ref("consumers/$fileName").putFile(image);
      String url = await storage.ref("consumers/$fileName").getDownloadURL();
      await firestore.collection("consumers").add({
        "name": name,
        "email": email,
        "phone": phone,
        "image": url,
        "consommation": foods,
      });
      return "Success";
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> deleteConsumer(String id) async {
    try {
      await firestore.collection("consumers").doc(id).delete();
      return "Success";
    } catch (e) {
      print(e);
      return null;
    }
  }
}
