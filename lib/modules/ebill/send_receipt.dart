import 'package:url_launcher/url_launcher_string.dart';


class SendReceipt {
  Future<bool> sendReceipt(Map<String, dynamic> receipt) async {
    String encodedMessage = Uri.encodeFull(receipt['text']);
    String phoneNumber = "+91${receipt['mobile']}";
    String url = 'https://api.whatsapp.com/send?phone=$phoneNumber&text=$encodedMessage';
    return await launchUrlString(url);
  }
}
