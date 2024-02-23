import 'dart:io';

class InternetConnectionCheck {
  static Future<bool> internetCheck() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ignore: use_build_context_synchronously
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
