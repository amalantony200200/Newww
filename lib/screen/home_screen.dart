import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malabar_mess_app/classes/internet_error_snackbar.dart';
import 'package:malabar_mess_app/classes/shared_preference.dart';
import 'package:malabar_mess_app/modules/passcode/screen/check_passcode_screen.dart';
import 'package:malabar_mess_app/screen/add_new_member_screen.dart';
import 'package:malabar_mess_app/screen/attendance_screen.dart';
import 'package:malabar_mess_app/screen/count_members_screen.dart';
import 'package:malabar_mess_app/screen/search_screen.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';
import 'package:malabar_mess_app/widget/snackbar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  HomeButton(
                    label: 'Search',
                    iconPath: 'assets/search_member.svg',
                    onTap: () {
                      // Navigate to Search page
                      functionalButtons(
                        context: context,
                        page: SearchScreen(),
                        title: "Enter passcode",
                      );
                    },
                  ),
                  HomeButton(
                    label: 'Add Member',
                    iconPath: 'assets/add_member.svg',
                    onTap: () {
                      // Navigate to Add Member page
                      functionalButtons(
                        context: context,
                        page: AddNewMemberScreen(),
                        title: "Enter passcode",
                      );
                    },
                  ),
                  HomeButton(
                    label: 'Take Attendance',
                    iconPath: 'assets/take_attendance.svg',
                    onTap: () {
                      // Navigate to Take Attendance page
                      functionalButtons(
                        context: context,
                        page: AttendanceScreen(),
                        title: "Enter passcode",
                      );
                    },
                  ),
                  HomeButton(
                    label: 'Daily Attendance',
                    iconPath: 'assets/daily_attendance.svg',
                    onTap: () {
                      // Navigate to Daily Attendance page
                      functionalButtons(
                        context: context,
                        page: CountMemberScreen(),
                        title: "Enter passcode",
                      );
                    },
                  ),
                  HomeButton(
                    label: 'Common Message',
                    iconPath: 'assets/common_message.svg',
                    onTap: () {
                      // Navigate to Common Message page
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatefulWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const HomeButton({
    required this.label,
    required this.iconPath,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.iconPath,
                height: 60,
              ),
              SizedBox(height: 10),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> functionalButtons({
  required context,
  required page,
  required title,
}) async {
  const String message = "Internet connection required";
  bool checkInternet = await InternetConnectionCheck.internetCheck();
  if (!context.mounted) return;
  if (checkInternet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasscodeScreen(
          title: title,
          passwordEnteredCallback: _onPasscodeEntered,
          shouldTriggerVerification: _verificationNotifier.stream,
          afterPasscodeCorrect: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
        ),
      ),
    );
  } else {
    ShowSnackBar(context: context, message: message);
  }
}

final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

_onPasscodeEntered(String enteredPasscode) async {
  SharedPreferenceClass obj = SharedPreferenceClass();
  int passcode = await obj.getSharedPreference();
  bool isValid = passcode == int.parse(enteredPasscode);
  _verificationNotifier.add(isValid);
}
