import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}
class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isResendButtonEnabled = false;
   Timer? _timer;
  int _start = 120; // 2 minutes in seconds
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendButtonEnabled = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
          _isResendButtonEnabled = false;
        });
      }
    });
  }

  String get _timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.8; // Adjust width as needed


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Stack(
        children: [
          _buildBackgroundImage(context),
          _buildContent(context, buttonWidth),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/elogo.png'),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double buttonWidth) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: MediaQuery.of(context).size.height * 0.35,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 18),
            Text(
              ' Verify Email!',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            _buildDescriptionText(),
            const SizedBox(height: 90),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isResendButtonEnabled ? () {
                // Add your logic to request another verification email
                setState(() {
                  _start = 120; // Reset the timer
                  _isResendButtonEnabled = false;
                  _startTimer();
                  AuthController.instance.resendVerificationEmail();
                });
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                fixedSize: Size(buttonWidth, 50),
              ),
              child: Text(
                _isResendButtonEnabled ? 'Resend Verification Email' : 'Resend in $_timerText',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildButton(
              context,
              'Back to Sign Up',
              Theme.of(context).colorScheme.secondary,
                  () {

                AuthController.instance.cancelVerification();
                // Add your logic to navigate back to the signup screen or other actions
              },
              buttonWidth,
            ),
           // _buildClickableText(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return RichText(
      text: TextSpan(
        text: 'We have sent a verification link to your email.\n ${AuthController.instance.cuser?.email}.',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          height: 1.7,

        ),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, VoidCallback onPressed, double buttonWidth) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        fixedSize: Size(buttonWidth, 50),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }


}












