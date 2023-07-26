import 'dart:io';
import 'package:approvisionnement/models/prov.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ProviderService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<Prov>> getProviders() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("providers").get();
      List<Prov> prov;
      if (snapshot.docs.isNotEmpty) {
        prov = snapshot.docs.map((e) => Prov.fromJson(e.data(), e.id)).toList();
        return prov;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<String?> updateProvider(
      String id, String name, String descri) async {
    try {
      DocumentReference providerRef = firestore.collection("providers").doc(id);
      await providerRef
          .update({"name": name, "descri": descri, "created": Timestamp.now()});
      return "success";
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addProvider(
      String name, String descri, File image, String product) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      final fileName = basename(image.path);
      await storage.ref("providers/$fileName").putFile(image);
      String url = await storage.ref("providers/$fileName").getDownloadURL();
      await firestore.collection("providers").add({
        "name": name,
        "descri": descri,
        "image": url,
        "product": product,
        "created": Timestamp.now(),
      });
      return "Success";
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> deleteProvider(String id) async{
    try{
      await firestore.collection("providers").doc(id).delete();
      return "Success";
    }catch (e){
      print(e);
      return null;
    }
  }
}
