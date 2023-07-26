import 'dart:io';
import 'package:approvisionnement/models/food_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FoodService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<FoodState>> getFoods() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("foods").get();
      List<FoodState> foods;
      if (snapshot.docs.isNotEmpty) {
        foods = snapshot.docs
            .map((e) => FoodState.fromJson(e.data(), e.id))
            .toList();
        return foods;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<String?> updateFood(
      String id, String name, String descri, int stock) async {
    try {
      DocumentReference ref = firestore.collection("foods").doc(id);
      await ref.update({"name": name, "descri": descri, "stock": stock});
      return "success";
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addFood(
      String name, String descri, File image, String unit) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      final fileName = basename(image.path);
      await storage.ref("foods/$fileName").putFile(image);
      String url = await storage.ref("foods/$fileName").getDownloadURL();
      await firestore.collection("foods").add({
        "name": name,
        "descri": descri,
        "image": url,
        "unit": unit,
        "stock": 0,
      });
      return "Success";
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> deleteFood(String id) async {
    try {
      await firestore.collection("foods").doc(id).delete();
      return "Success";
    } catch (e) {
      print(e);
      return null;
    }
  }
}
