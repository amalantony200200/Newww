import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';
import 'package:malabar_mess_app/model/all_member_details.dart';
import 'package:malabar_mess_app/model/member_details.dart';

class GetDatabaseData {
  final CollectionReference<Map<String, dynamic>> messDetailsCollection =
      FirebaseFirestore.instance.collection("MessDetails");
  final CollectionReference<Map<String, dynamic>> messMembersCollection =
      FirebaseFirestore.instance.collection("MembersDetails");
  static List<MemberDetails>allMembersList = [];

  Future<int> getMessUniquePasscode() async {
    String passcode = await messDetailsCollection
        .doc("MalabarMess")
        .get()
        .then((value) => value.get("MessUniquePasscode"));
    //mainCollection.then((value) => print(value.get("MessUniquePasscode")));
    return int.parse(passcode);
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await messMembersCollection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfPhoneNumberExists(String docId) async {
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
        memberValidFrom: doc.get("memberValidFrom"),
        memberValidTill: doc.get("memberValidTill"),
        memberExtends: doc.get("memberExtends"),
      );
      allMembersDocs.add(memberDetails);
    }
    final AllMemberDetails controller = Get.put(AllMemberDetails());
    allMembersList.clear();
    allMembersList.addAll(allMembersDocs);
    controller.initializeList(allMembersList);
  }
}
