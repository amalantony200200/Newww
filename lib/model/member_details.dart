import 'package:get/get.dart';

class MemberDetails{
  
  final String memberId;
  final String memberName;
  final String memberNumber;
  final String memberPaidAmount;
  final String memberFoodTime;
  final DateTime memberValidFrom;
  final DateTime memberValidTill;
  final Map<String,dynamic> memberExtends;
  
  MemberDetails({required this.memberId, required this.memberName, required this.memberNumber, required this.memberPaidAmount, required this.memberFoodTime, required this.memberValidFrom, required this.memberValidTill, required this.memberExtends});
  
}

