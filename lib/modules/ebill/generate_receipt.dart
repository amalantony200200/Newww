import 'package:malabar_mess_app/model/member_details.dart';

class GenerateReceipt {
  Future<Map<String, dynamic>> receipt(MemberDetails memberDetails) async {
    Map<String, dynamic> mapOfBill = {};
    String eReceiptText = '''
-----------------------------------------------------------
            *Malabar Mess E-Receipt*                 
-----------------------------------------------------------

Student Name: *${memberDetails.memberName}*
Registration Number: *${memberDetails.memberId}*
Mobile Number: ${memberDetails.memberNumber}

Mess Subscription Details:
Number of Days:*${memberDetails.memberValidTill.difference(memberDetails.memberValidFrom)}*
Start Date:${memberDetails.memberValidFrom}
End Date: *${memberDetails.memberValidTill}*

Payment Details:
Total Amount: ${memberDetails.memberPaidAmount}
Payment Method: Online

Thank you for choosing Malabar Mess! If you have any questions or concerns, please feel free to contact us.

-----------------------------------------------------------
''';
    mapOfBill = {
      'text': eReceiptText,
      'mobile': memberDetails.memberNumber
    };
    return mapOfBill;
  }

}
