import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:malabar_mess_app/model/member_details.dart';

class AllMemberDetails extends GetxController{
  RxList<MemberDetails> allMemberList = RxList<MemberDetails>();
  void initializeList(List<MemberDetails> list) {
    allMemberList.assignAll(list);
  }
}