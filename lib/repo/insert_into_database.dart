import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:malabar_mess_app/controller/add_controller.dart';
import 'package:malabar_mess_app/model/member_details.dart';
import 'package:malabar_mess_app/repo/get_database_data.dart';

class InsertIntoDatabase {
  final CollectionReference<Map<String, dynamic>> membersDetailsCollection =
      FirebaseFirestore.instance.collection("MembersDetails");

  final CollectionReference<Map<String, dynamic>> membersAttendanceCollection =
      FirebaseFirestore.instance.collection("Attendance");


  Future<bool> addMemberDetails({required MemberDetails memberDetails}) async {
    bool isAdded = false;
    await membersDetailsCollection.doc(memberDetails.memberId).set({
      'memberId': memberDetails.memberId,
      'memberName': memberDetails.memberName,
      'memberPhone': memberDetails.memberNumber,
      'memberPaidAmount': memberDetails.memberPaidAmount,
      'memberFoodTime': memberDetails.memberFoodTime,
      'memberValidFrom': memberDetails.memberValidFrom,
      'memberValidTill': memberDetails.memberValidTill,
      'memberExtendsStart': memberDetails.memberExtendsStart,
      'memberExtendsEnd': memberDetails.memberExtendsEnd,
    }).then(
      (value) {
        isAdded = true;
      },
    );
    //await membersAttendanceCollection.doc(memberDetails.memberId).set({}).then((value) => null);
    return isAdded;
  }

  Future<bool> updateMemberDetails({required MemberDetails memberDetails}) async {
    bool isUpdate = false;
    try {
      final GetDatabaseData obj = GetDatabaseData();
      final bool checkIfDocExists =
          await obj.checkIfDocExists(memberDetails.memberId);
      if (checkIfDocExists == false) {
        isUpdate = false;
        return isUpdate;
      } else {
        final member = {
          'memberId': memberDetails.memberId,
          'memberName': memberDetails.memberName,
          'memberPhone': memberDetails.memberNumber,
          'memberPaidAmount': memberDetails.memberPaidAmount,
          'memberFoodTime': memberDetails.memberFoodTime,
          'memberValidFrom': memberDetails.memberValidFrom,
          'memberValidTill': memberDetails.memberValidTill,
          'memberExtendsStart': memberDetails.memberExtendsStart,
          'memberExtendsEnd': memberDetails.memberExtendsEnd,
        };

        await membersDetailsCollection
            .doc(memberDetails.memberId)
            .update(member)
            .then((value) {
          isUpdate = true;
          return isUpdate;
        }).catchError((error) {
          isUpdate = false;
          return isUpdate;
        });
      }
    } on SocketException catch (_) {
      return isUpdate;
    }
    return isUpdate;
  }

  Future<bool> addAttendance(String memberId, AddScreenProvider provider1) async {
    bool isAdded = false;
    await membersAttendanceCollection.doc(DateFormat('MMM d').format(DateTime.now()).toString()).update({
      memberId:provider1.foodTime
    }).then(
      (value) {
        isAdded = true;
      },
    );
    //await membersAttendanceCollection.doc(memberDetails.memberId).set({}).then((value) => null);
    return isAdded;
  }
}
