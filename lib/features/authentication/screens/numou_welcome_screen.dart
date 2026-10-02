
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:numou/features/authentication/screens/sign_in.dart';
import 'package:numou/features/authentication/screens/sign_up.dart';

class NumouWelcomeScreen extends StatelessWidget {
  const NumouWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcome_screen_background.png',
                fit: BoxFit.cover,
              ),
            ),
        
            Positioned(
              top: size.height * 0.025,
              left: size.width * 0.77,
              width: size.width * 0.30,
              height: size.height * 0.13,
              child: Image.asset(
                'assets/images/welcome_character_1.png',
                height: size.height * 0.25,
                width: size.width * 0.25,
              ),
            ),
            Positioned(
              top: size.height * 0.020,
              left: 0,
              width: size.width * 1,
              height: size.height * 0.90,
              child: Image.asset(
                'assets/images/welcome_rainbow.png',
                height: size.height * 0.25,
                width: size.width * 0.25,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: size.height * 0.238,
              left: 0,
              width: size.width * 0.25,
              height: size.height * 0.20,
              child: Image.asset(
                'assets/images/welcome_character_3.png',
                height: size.height * 0.25,
                width: size.width * 0.25,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: size.height * 0,
              left: size.height*0.015,
              width: size.width * 0.16,
              height: size.height * 0.08,
              child: Image.asset(
                'assets/images/welcome_character_4.png',
                height: size.height * 0.25,
                width: size.width * 0.25,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: size.height * 0,
              right: size.height*0.015,
              width: size.width * 0.16,
              height: size.height * 0.08,
              child: Image.asset(
                'assets/images/welcome_character_5.png',
                height: size.height * 0.25,
                width: size.width * 0.25,
                fit: BoxFit.fill,
              ),
            ),
            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  //  SizedBox(height: size.height * 0.115),
                    SizedBox(height: size.height*0.04),
                    Image.asset(
                      'assets/images/numou_logo.png',
                      height: size.height * 0.30,
                      width: size.width * 0.55,
                      fit: BoxFit.fill,
                    ),
        
                    SizedBox(height: size.height * 0.04),
        
                    // Welcome Text
                    Text(
                      'welcome.welcome'.tr,
                      style: TextStyle(
                        fontSize: size.width * 0.07,
                        fontWeight: FontWeight.bold,
        
                        color: Color(0xFFFF8103),
        
                      ),
                    ),
        
                    SizedBox(height: 12),
        
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'welcome.description'.tr,
        
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Color(0xFF023047),
        
        
                        ),
                      ),
                    ),
        
                    SizedBox(height: size.height*0.02),
        
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color of the button
                            borderRadius: BorderRadius.circular(12),
                            // border: Border.all(
                            //   color: Color(0xFFE5E5E5), // Border color
                            //   width: 2, // Border thickness
                            // ),
                            boxShadow: [
                              BoxShadow(
                                color:Color(0xFF58A700)
                                , // Shadow color
                                spreadRadius: 0.0,
                                blurRadius: 0.0,
                                offset: Offset(0, 4), // Only bottom shadow
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(()=>SignUp());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF58CC02)
                              ,
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.01,
                                horizontal: size.width * 0.04,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'welcome.createAccount'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.038,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
        
                        SizedBox(width: size.width*0.00),
        
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color of the button
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
                              Get.to(()=>SignIn());
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
                              'welcome.login'.tr,
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
        
                    //SizedBox(height: size.height*0.00),
        
                    // Bottom character (child on pencil)
                    Image.asset(
                      'assets/images/welcome_character_2.png',
                      height: size.height * 0.36,
                      width: size.width * 0.80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
