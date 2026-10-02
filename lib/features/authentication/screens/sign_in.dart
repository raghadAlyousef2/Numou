import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/features/authentication/screens/sign_up.dart';
import 'package:numou/features/authentication/screens/sing_in_pre.dart';
import '../controllers/auth_controller.dart';
import 'forget_password.dart';
class SignIn extends StatelessWidget {
  SignIn({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var authController =Get.find<AuthController>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return; // only run after an actual pop


        authController.clearFocus();                 // unfocus all fields
        authController.clearErrors();                // clear validation errors
        authController.isPasswordVisible.value = true;
      },
      child: Scaffold(
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
                          'login.title'.tr,
                          style: TextStyle(
                            fontSize: size.height * 0.035,
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
                // SizedBox(height: size.height * 0.01),
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

                        Row(
                          children: [
                            Text(
                              'signup.email'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.025,
                                color: Color.fromRGBO(2, 48, 71, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Obx(
                              ()=> Directionality(
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
                                    color:
                                    Colors.grey, // Gray border when not focused
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(2, 48, 71, 1), // Gray border when focused
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: size.width*0.01,
                                  vertical: size.height*0.01,
                                ),
                                errorText: authController.emailError.value.isEmpty
                                    ? null
                                    : authController.emailError.value.tr,
                              ),
                              style: TextStyle(fontSize: size.height*0.02,color: Color.fromRGBO(2, 48, 71, 1)),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Text(
                              'login.password'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.025,
                                color: Color.fromRGBO(2, 48, 71, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Obx(
                              ()=> TextField(
                            focusNode: authController.passwordFocus,
                            obscureText: authController.isPasswordVisible.value,
                            obscuringCharacter: '*',
                            controller: _passwordController,
                            // Arabic text direction
                            decoration: InputDecoration(
                              hintText: '*************',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    authController
                                        .togglePasswordVisibility();
                                  },
                                  icon:Icon(
                                    authController.isPasswordVisible.value
                                        ?
                                    Icons.visibility_off: Icons.visibility,
                                  )),
                              hintStyle: TextStyle(
                                color: Colors.grey, // Gray hint text
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color:
                                  Colors.grey, // Gray border when not focused
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(2, 48, 71, 1), // Gray border when focused
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: size.width*0.01,
                                vertical: size.height*0.01,
                              ),
                              errorText: authController.passwordError.value.isEmpty
                                  ? null
                                  : authController.passwordError.value.tr,
                            ),
                            style: TextStyle(fontSize: size.height*0.02,color: Color.fromRGBO(2, 48, 71, 1)),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                authController.clearErrors();
                                authController.clearFocus();
                                Get.off(()=> ForgetPassword(prefillEmail: _emailController.text.trim()));
                              },
                              child: Text(
                                'login.forgotPassword'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.height * 0.018,
                                  color: Color.fromRGBO(255, 129, 3, 1),
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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
                          child: ElevatedButton(
                            onPressed: () {

                              authController.login(email: _emailController.text.trim(), password: _passwordController.text.trim());
                              //authController.register(email: emailController.text.trim(), password: passwordController.text.trim(), name: nameController.text.trim(), birthYear: birthYearController.text.trim());

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
                              'login.loginButton'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.038,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        RichText(

                          text: TextSpan(
                            text: 'login.noAccount'.tr,
                            style: TextStyle(
                              color: Color(0xFF1F3B53), // Dark blue (adjust as needed)
                              fontSize: size.height * 0.022,
                            ),
                            children: [
                              TextSpan(
                                text: 'login.createAccount'.tr,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: size.height * 0.023,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to login or perform action
                                    authController.clearErrors();
                                    authController.clearFocus();
                                    authController.isPasswordVisible.value=true;
                                    Get.off(()=>SignUp()); // Example with GetX navigation
                                  },
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.2),
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
}
