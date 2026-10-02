
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numou/features/authentication/screens/sing_up_pre.dart';
import 'package:numou/features/authentication/screens/sing_in_pre.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E6891),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Let’s get started!',
                  style: GoogleFonts.sansita(
                    fontSize: 48,
                    fontWeight: FontWeight.normal, // Regular weight
                    color: Colors.white,
                  ),
                ),
                //SizedBox(height: 20), // Add space between text and image
                Image.asset(
                  'assets/elogo.png',
                  width: 450, // Adjust width as needed
                  height: 450, // Adjust height as needed
                ),
                // SizedBox(height: 20), // Add space between image and buttons
                ElevatedButton(
                  onPressed: () {
                   Get.to(  ()=> SignUpPre(isOwner: true,));
                    // Handle button 1 action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBCD22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 108,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'Sign Up as owner',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                   Get.to(()=> SignUpPre(isOwner: false,));
                    // Handle button 2 action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBCD22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'Sign up as member',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => Get.to( ()=> SignInPre()),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 16,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Already logged in?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: ' Sign in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFBCD22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
