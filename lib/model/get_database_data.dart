import 'package:cloud_firestore/cloud_firestore.dart';

class GetDatabaseData {
  final CollectionReference<Map<String, dynamic>> mainCollection = FirebaseFirestore.instance.collection("MalabarMess");
  Future<int> getMessUniquePasscode() async {
    int passcode = await mainCollection.doc("MessDetails").get().then((value) => value.get("MessUniquePasscode"));
    //mainCollection.then((value) => print(value.get("MessUniquePasscode")));
    return passcode;
  }
}
