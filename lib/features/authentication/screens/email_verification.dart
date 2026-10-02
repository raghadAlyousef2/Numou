import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var authController = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill,
              ),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width * 0.002),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(194, 237, 251, 0.7),
                          // Light blue background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'verification.title'.tr,
                          style: TextStyle(
                            fontSize: size.height * 0.020,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(2, 48, 71, 1),
                            // Dark blue text color
                            // Use Arabic-friendly font (optional)
                          ),
                          //  textDirection: TextDirection.rtl,
                        ),
                      ),
                      Image.asset(
                        "assets/images/numou_logo.png",
                        height: size.height * 0.13,
                        width: size.width * 0.22,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // Shadow color
                          spreadRadius: 0.0,
                          blurRadius: 2,
                          offset: Offset(0, 5), // Only bottom shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.03),
                        Text(
                          'verification.description'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: size.height * 0.022,
                            color: Color.fromRGBO(2, 48, 71, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.03),


                        InkWell(
                          onTap: () =>
                              _openEmail(authController.cuser?.email ?? ''),
                          child: Text(
                            authController.cuser?.email ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: size.height * 0.022,
                              color: const Color.fromRGBO(2, 48, 71, 1),
                              decoration: TextDecoration
                                  .underline, // look like a link
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: size.height * 0.03),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Background color of the button
                            borderRadius: BorderRadius.circular(12),
                            // border: Border.all(
                            //   color: Color(0xFFE5E5E5), // Border color
                            //   width: 2, // Border thickness
                            // ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF58A700), // Shadow color
                                spreadRadius: 0.0,
                                blurRadius: 0.0,
                                offset: Offset(0, 4), // Only bottom shadow
                              ),
                            ],
                          ),
                          child: Obx(
                                () =>
                                ElevatedButton(
                                  onPressed:
                                  authController.isResendButtonEnabled.value
                                      ? () {
                                    authController.resendVerificationEmail();
                                  }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF58CC02),
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01,
                                      horizontal: size.width * 0.04,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: size.width * 0.038,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          authController
                                              .isResendButtonEnabled
                                              .value
                                              ? 'verification.resend'.tr
                                              : 'verification.resendIn'.tr,
                                        ),
                                        if (!authController
                                            .isResendButtonEnabled
                                            .value)
                                          TextSpan(
                                            text: authController.timerText(
                                                authController.resendCount.value
                                            ),
                                            style: TextStyle(
                                              color: Colors
                                                  .orange, // Different color for seconds (optional)
                                            ),
                                          ),

                                      ],
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Background color of the button
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(0xFFE5E5E5), // Border color
                              width: 2, // Border thickness
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFE5E5E5), // Shadow color
                                spreadRadius: 0.1,
                                blurRadius: 0.1,
                                offset: Offset(0, 1), // Only bottom shadow
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              authController.cancelVerification();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              // Make transparent to show Container color
                              shadowColor: Colors.transparent,
                              // Disable default shadow
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.01,
                                horizontal: size.width * 0.06,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'verification.backToSignup'.tr,
                              style: TextStyle(
                                fontSize: size.width * 0.038,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1CB0F6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/auth_character_1.png',
                      height: size.height * 0.20,
                      width: size.width * 0.32,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _openEmail(String email) async {
    if (email.isEmpty) return;

    // Prefer Gmail compose on web (opens in a new tab)
    if (kIsWeb) {
      final gmail = Uri.parse(
          'https://mail.google.com/mail/?view=cm&fs=1&to=$email');
      if (await canLaunchUrl(gmail)) {
        await launchUrl(gmail, webOnlyWindowName: '_blank');
        return;
      }
    }

    // Fallback/default: open system mail client
    final mailto = Uri(scheme: 'mailto', path: email);
    await launchUrl(
      mailto,
      mode: LaunchMode.externalApplication,
    );
  }

}
