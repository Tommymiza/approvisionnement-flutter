
import 'package:approvisionnement/models/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<History>> getHistories() async {
    try {
      QuerySnapshot snapshot = await firestore.collection("history").get();
      List<History> histories;
      if (snapshot.docs.isNotEmpty) {
        histories = snapshot.docs
            .map((e) => History.fromJson(e.data(), e.id))
            .toList();
        return histories;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<String?> addHistories(String email, String actor, String product, String quantity, String type) async {
    try{
      CollectionReference ref = firestore.collection("history");
      await ref.add({
        "actor": actor,
        "email": email,
        "product": product,
        "quantity": quantity,
        "type": type,
        "date": Timestamp.now()
      });
      return "Success";
    }catch (e){
      print(e);
      return null;
    }
  }
}