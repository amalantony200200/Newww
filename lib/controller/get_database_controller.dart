import 'package:flutter/material.dart';
import 'package:malabar_mess_app/model/member_details.dart';

class GetDatabaseController extends ChangeNotifier{

  static List<MemberDetails> memberDetailsStatic= [];
  List<MemberDetails> sortedMemberDetails = [];
  static Map<String,String> attendance ={};
  get memberDetails => memberDetailsStatic;
  
  void setMemberDetails(List<MemberDetails> memberDetails){
    memberDetailsStatic.clear();
    memberDetailsStatic.addAll(memberDetails);
    notifyListeners();
  }
   void setSortedMemberDetails(List<MemberDetails> memberDetails){
    sortedMemberDetails.clear();
    sortedMemberDetails.addAll(memberDetails);
    notifyListeners();
  }
  void setAttendanceMap(Map<String,String> map){
    attendance.clear();
    attendance.addAll(map);
    notifyListeners();
  }
}