import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:malabar_mess_app/controller/get_database_controller.dart';

import 'package:malabar_mess_app/model/member_details.dart';

class GetDatabaseData {
  static final GetDatabaseData _singleton = GetDatabaseData._internal();

  factory GetDatabaseData() {
    return _singleton;
  }
  GetDatabaseData._internal();

  final CollectionReference<Map<String, dynamic>> messDetailsCollection =
      FirebaseFirestore.instance.collection("MessDetails");
  final CollectionReference<Map<String, dynamic>> messMembersCollection =
      FirebaseFirestore.instance.collection("MembersDetails");
  final CollectionReference<Map<String, dynamic>> attendance =
      FirebaseFirestore.instance.collection("Attendance");


  Future<int> getMessUniquePasscode() async {
    String passcode = await messDetailsCollection
        .doc("MalabarMess")
        .get()
        .then((value) => value.get("MessUniquePasscode"));
    //mainCollection.then((value) => print(value.get("MessUniquePasscode")));
    return int.parse(passcode);
  }

  bool checkIfPhoneExists(String mobile) {
    bool isExists = false;
    final allMemberDocs = GetDatabaseController.memberDetailsStatic;
    for (int i = 0; i < allMemberDocs.length; i++) {
      if (allMemberDocs[i].memberNumber == mobile) {
        isExists = true;
        break;
      }
    }
    return isExists;
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await messMembersCollection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllMembersDocs() async {
    List<MemberDetails> allMembersDocs = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await messMembersCollection.get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      final doc = snapshot.docs[i];
      MemberDetails memberDetails = MemberDetails(
        memberId: doc.get("memberId"),
        memberName: doc.get("memberName"),
        memberNumber: doc.get("memberPhone"),
        memberPaidAmount: doc.get("memberPaidAmount"),
        memberFoodTime: doc.get("memberFoodTime"),
        memberValidFrom: doc.get("memberValidFrom").toDate(),
        memberValidTill: doc.get("memberValidTill").toDate(),
        memberExtendsStart: doc.get("memberExtendsStart").map((timestamp) {
          return timestamp.toDate();
        }).toList(),
        memberExtendsEnd: doc.get("memberExtendsEnd").map((timestamp) {
          return timestamp.toDate();
        }).toList(),
      );
      allMembersDocs.add(memberDetails);
    }
    GetDatabaseController controller = GetDatabaseController();
    controller.setMemberDetails(allMembersDocs);
  }

  Future<void> getAttendance(String date) async {
    var doc = await attendance.doc(date).get();
    if(!doc.exists){
      await attendance.doc(date).set({}).then((value) => null);
    }
    final snapshot =
        await attendance.doc(date).get().then((value){
          return value.data();
        });
    Map<String,String> objMap={};
    snapshot?.forEach((key, value) { 
       objMap[key]=value;
    });
    GetDatabaseController controller = GetDatabaseController();
    controller.setAttendanceMap(objMap);
    // controller.setMemberDetails(allMembersDocs);
  }
}
