import 'package:get/get.dart';

class MemberDetails{
  
  final String memberId;
  final String memberName;
  final String memberNumber;
  final String memberPaidAmount;
  final String memberFoodTime;
  final DateTime memberValidFrom;
  final DateTime memberValidTill;
  final List memberExtendsStart;
  final List memberExtendsEnd;
  
  
  MemberDetails({required this.memberExtendsStart, required this.memberExtendsEnd,required this.memberId, required this.memberName, required this.memberNumber, required this.memberPaidAmount, required this.memberFoodTime, required this.memberValidFrom, required this.memberValidTill});
  
}

