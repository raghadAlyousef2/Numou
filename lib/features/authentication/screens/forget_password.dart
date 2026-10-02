import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/features/authentication/screens/sign_in.dart';
import 'package:numou/features/authentication/screens/sign_up.dart';
import '../controllers/auth_controller.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key, required this.prefillEmail});

  String prefillEmail;
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emailController.text = prefillEmail;
    var size = MediaQuery.sizeOf(context);
    var authController = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                padding: const EdgeInsets.all(12.0),
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
                        'forgetPassword.title'.tr,
                        style: TextStyle(
                          fontSize: size.height * 0.025,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin:  EdgeInsets.symmetric(horizontal: size.width*.03),
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(size.width*0.07),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),


                      child: IconButton(onPressed: (){
                        authController.clearErrors();
                        authController.clearFocus();
                        Get.off(()=>SignIn());
                      }, icon: Icon(Icons.arrow_forward,size: size.width*0.07,color: Colors.black,))),
                ],
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
                      SizedBox(height: size.height * 0.04),
                      Text(
                        'forgetPassword.enterEmail'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: size.height * 0.022,
                          color: Color.fromRGBO(2, 48, 71, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.04),

                      Obx(
                        () => Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextField(
                            focusNode: authController.emailFocus,
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'signup.email.hint'.tr,

                              hintStyle: TextStyle(
                                color: Colors.grey,
                                // Gray hint text
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors
                                      .grey, // Gray border when not focused
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(
                                    2,
                                    48,
                                    71,
                                    1,
                                  ), // Gray border when focused
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01,
                                vertical: size.height * 0.01,
                              ),
                              errorText: authController.emailError.value.isEmpty
                                  ? null
                                  : authController.emailError.value.tr,
                            ),
                            style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Color.fromRGBO(2, 48, 72, 1),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),
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
                        child: ElevatedButton(
                          onPressed: () {
                            authController.sendResetPasswordEmail(
                              _emailController.text.trim(),
                            );
                          },

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
                          child: Text(
                            'forgetPassword.resetButton'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: size.width * 0.038,
                              color: Color(0xFFFFFFFF),
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
    );
  }
}
