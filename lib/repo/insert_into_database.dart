import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:malabar_mess_app/model/member_details.dart';

class InsertIntoDatabase{
  final CollectionReference<Map<String, dynamic>> membersDetailsCollection = FirebaseFirestore.instance.collection("MembersDetails");
  Future<bool> addMemberDetails({required MemberDetails memberDetails}) async{
    bool isAdded = false;
    await membersDetailsCollection.doc(memberDetails.memberId).set({
      'memberId':memberDetails.memberId,
      'memberName':memberDetails.memberName,
      'memberPhone':memberDetails.memberNumber,
      'memberPaidAmount':memberDetails.memberPaidAmount,
      'memberFoodTime':memberDetails.memberFoodTime,
      'memberValidFrom':memberDetails.memberValidFrom,
      'memberValidTill':memberDetails.memberValidTill,
      'memberExtends':memberDetails.memberExtends,
    }).then((value) {
      isAdded = true;
    },);
    return isAdded;
  }
}