import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/features/authentication/screens/sign_in.dart';
import 'package:numou/features/authentication/screens/sing_in_pre.dart';
import '../controllers/auth_controller.dart';
// import 'package:intl/intl.dart';
class SignUp extends StatelessWidget {
  SignUp({super.key});

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ConfirmPasswordController = TextEditingController();
  final _birthYearController = TextEditingController();


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
        authController.isConfirmPasswordVisible.value = true;
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
                          'signup.title'.tr,
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
                              'signup.name'.tr,
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
                            focusNode: authController.nameFocus,
                           controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'signup.name.hint'.tr,
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
                              errorText: authController.nameError.value.isEmpty
                                  ? null
                                  : authController.nameError.value.tr,
                            ),
                            style: TextStyle(fontSize: size.height*0.02,color: Color.fromRGBO(2, 48, 71, 1)),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
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
                              'signup.password'.tr,
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
                        ), Row(
                          children: [
                            Text(
                              'signup.confirm.password'.tr,
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
                            focusNode: authController.confirmPasswordFocus,
                            obscureText: authController.isConfirmPasswordVisible.value,
                            obscuringCharacter: '*',
                            controller: _ConfirmPasswordController,
                            // Arabic text direction
                            decoration: InputDecoration(
                              hintText: '*************',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    authController
                                        .toggleConfirmPasswordVisibility();
                                  },
                                  icon:Icon(
                                    authController.isConfirmPasswordVisible.value
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
                              errorText: authController.confirmPasswordError.value.isEmpty
                                  ? null
                                  : authController.confirmPasswordError.value.tr,
                            ),
                            style: TextStyle(fontSize: size.height*0.02,color: Color.fromRGBO(2, 48, 71, 1)),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Text(
                              'signup.birthYear'.tr,
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

                                 () => TextField(
                               focusNode: authController.birthYearFocus,
                               controller: _birthYearController,
                               readOnly: true,                          // open date picker instead of typing
                               onTap: () => _pickBirthDate(context),
                               textDirection: TextDirection.ltr,        // numbers look nicer LTR
                               decoration: InputDecoration(
                                 hintText: '2010',
                                 hintStyle: const TextStyle(color: Colors.grey),
                                 suffixIcon: IconButton(
                                   icon: const Icon(Icons.calendar_month_rounded),
                                   onPressed: () => _pickBirthDate(context),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5),
                                   borderSide: const BorderSide(color: Colors.grey),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5),
                                   borderSide: const BorderSide(color: Color.fromRGBO(2, 48, 71, 1)),
                                 ),
                                 contentPadding: EdgeInsets.symmetric(
                                   horizontal: size.width * 0.01,
                                   vertical: size.height * 0.01,
                                 ),
                                 errorText: authController.birthYearError.value.isEmpty
                                     ? null
                                     : authController.birthYearError.value.tr,
                               ),
                               style: TextStyle(
                                 fontSize: size.height * 0.02,
                                 color: const Color.fromRGBO(2, 48, 71, 1),
                               ),
                             ),
                           ),


                         // TextField(
                          //   focusNode: authController.birthYearFocus,
                          //  controller: _birthYearController,
                          //   // Arabic text direction
                          //   decoration: InputDecoration(
                          //     hintText: '2010',
                          //     hintStyle: TextStyle(
                          //       color: Colors.grey, // Gray hint text
                          //     ),
                          //     enabledBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(5),
                          //       borderSide: BorderSide(
                          //         color:
                          //         Colors.grey, // Gray border when not focused
                          //       ),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(5),
                          //       borderSide: BorderSide(
                          //         color: Color.fromRGBO(2, 48, 71, 1), // Gray border when focused
                          //       ),
                          //     ),
                          //     contentPadding: EdgeInsets.symmetric(
                          //       horizontal: size.width*0.01,
                          //       vertical: size.height*0.01,
                          //     ),
                          //     errorText: authController.birthYearError.value.isEmpty
                          //         ? null
                          //         : authController.birthYearError.value.tr,
                          //   ),
                          //   style: TextStyle(fontSize: size.height*0.02,color: Color.fromRGBO(2, 48, 71, 1)),
                          // ),

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

                             authController.register(email: _emailController.text.trim(), password: _passwordController.text.trim(), name: _nameController.text.trim(), birthYear: _birthYearController.text.trim(),confirmPassword: _ConfirmPasswordController.text.trim());

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
                              'signup.createAccount'.tr,
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
                            text: 'signup.haveAccount'.tr,
                            style: TextStyle(
                              color: Color(0xFF1F3B53), // Dark blue (adjust as needed)
                              fontSize: size.height * 0.022,
                            ),
                            children: [
                              TextSpan(
                                text: 'signup.login'.tr,
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
                                    Get.off(()=>SignIn()); // Example with GetX navigation
                                  },
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),

                 SizedBox(height: size.height * 0.03),
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
  Future<void> _pickBirthDate(BuildContext context) async {
    final now = DateTime.now();

    // If user already typed/picked something, try to use it as initial date
    DateTime? initial;
    final txt = _birthYearController.text.trim();
    if (txt.isNotEmpty) {
      // handles either yyyy or yyyy-MM-dd
      try {
        initial = txt.length <= 4
            ? DateTime(int.parse(txt), 1, 1)
            : DateTime.parse(txt);
      } catch (_) {}
    }
    initial ??= DateTime(now.year - 8, 1, 1); // sensible default

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 100), // adjust as you like
      lastDate: now,
      //locale: Get.locale,                  // use your current app locale
      helpText: 'اختر تاريخ الميلاد',        // header text
      cancelText: 'إلغاء',
      confirmText: 'تم',
    );

    if (picked != null) {
      // Store just the YEAR to keep compatibility with your current register()
      _birthYearController.text = picked.year.toString();
      // If you prefer full date later, use: DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
