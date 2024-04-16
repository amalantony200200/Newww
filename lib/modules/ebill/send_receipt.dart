import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_share/flutter_share.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:malabar_mess_app/model/member_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class SendReceipt {
  Future<bool> sendReceipt(Map<String, dynamic> receipt) async {
    String encodedMessage = Uri.encodeFull(receipt['text']);
    String phoneNumber = receipt['mobile'];
    String url = 'https://api.whatsapp.com/send?phone=$phoneNumber&text=$encodedMessage';
    return await launchUrlString(url);
  }
}
