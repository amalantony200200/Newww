import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:malabar_mess_app/model/all_member_details.dart';
import 'package:malabar_mess_app/model/member_details.dart';
import 'package:malabar_mess_app/repo/get_database_data.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AllMemberDetails allMemberDetails = Get.put(AllMemberDetails());

    return Scaffold(
      appBar:appBar(),
      body: Column(
        children: [
          TextFormField(
            controller: _searchField,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Search member ID or Name",
              labelText: "Member",
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              displayList(value);
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: allMemberDetails.allMemberList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(allMemberDetails.allMemberList[index].memberName),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  void displayList(String value){
    List<MemberDetails>membersList = []; 
    final allList=GetDatabaseData.allMembersList;
    if(value.isNum){
      for(int i=0;i<allList.length;i++){
        if(value == allList[i].memberId){
          membersList.add(allList[i]);
        }
      }
    }else{
      for(int i=0;i<allList.length;i++){
        if(allList[i].memberName.toLowerCase().contains(value.toLowerCase())){
          membersList.add(allList[i]);
        }
      }
    }
    final AllMemberDetails controller = Get.put(AllMemberDetails());
    controller.initializeList(membersList);
  }
}
