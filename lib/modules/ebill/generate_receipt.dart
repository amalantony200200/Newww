import 'package:intl/intl.dart';
import 'package:malabar_mess_app/model/member_details.dart';

class GenerateReceipt {
  Future<Map<String, dynamic>> receipt(MemberDetails memberDetails) async {
    String breakfast = (memberDetails.memberFoodTime[0]=='1')?"BreakFast ":"";
    String lunch = (memberDetails.memberFoodTime[1]=='1')?"Lunch ":"";
    String dinner = (memberDetails.memberFoodTime[2]=='1')?"Dinner":""; 
    Map<String, dynamic> mapOfBill = {};
    String eReceiptText = '''
--------------------------------------------------------
            *Malabar Mess E-Receipt*                 
--------------------------------------------------------

Student Name: *${memberDetails.memberName}*
Registration Number: *${memberDetails.memberId}*
Mobile Number: ${memberDetails.memberNumber}

Mess Subscription Details:
Number of Days:*${memberDetails.memberValidTill.add(const Duration(days: 1)).difference(memberDetails.memberValidFrom).inDays.toString}*
Food Time: ${breakfast + lunch + dinner}
Start Date: ${DateFormat('d/M/y').format(memberDetails.memberValidFrom)}
End Date: *${DateFormat('d/M/y').format(memberDetails.memberValidTill)}*

Payment Details:
Total Amount: ${memberDetails.memberPaidAmount}
Payment Method: Online

Thank you for choosing Malabar Mess! If you have any questions or concerns, please feel free to contact us.

--------------------------------------------------------
''';
    mapOfBill = {
      'text': eReceiptText,
      'mobile': memberDetails.memberNumber
    };
    return mapOfBill;
  }

}
