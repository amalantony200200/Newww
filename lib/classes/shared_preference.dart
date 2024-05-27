import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceClass{
  late SharedPreferences _prefs;
  Future<bool> setSharedPreference({required int passcode}) async{
    _prefs = await SharedPreferences.getInstance();
    bool flag = false;
    flag = await _prefs.setInt('localPasscode', passcode);
    return flag;
  }
  Future<int> getSharedPreference() async{
    _prefs = await SharedPreferences.getInstance();
    int passcode = _prefs.getInt('localPasscode')?? 0;
    return passcode;
  }
}