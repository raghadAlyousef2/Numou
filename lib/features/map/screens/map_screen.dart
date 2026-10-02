import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/utiles/Constant/helper_funciton.dart';

import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../utiles/Widgets/arabic_progress_bar.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';
import '../../authentication/controllers/auth_controller.dart';
import '../../dashbaord/screens/character_select_screen.dart';
import '../../dashbaord/screens/child_dashboard.dart';
import '../../dashbaord/screens/widgets/skill_badges.dart';
import '../../levels/screens/level_screen.dart';
import '../controllers/levels_map_controller.dart';
import '../widgets/level_map_widget.dart';


class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final LevelsMapController c = Get.put(LevelsMapController());
  final data = Get.find<NamouFirebaseDataController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authController=Get.find<AuthController>();
    final fabColor = const Color(0xFFFF8C2E);
    return   Obx(
            ()=> GrayscaleWidget(
          isGrayscale: !data.isOnline.value,
          isAbsorb: false,

          child:Scaffold(
          backgroundColor: const Color(0xFFEFF8E6),

         floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight ), // Extra space if needed
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: size.width*0.00, vertical: size.height*0.001), // Padding for whole AppBar
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.orange, width: 1), // Lower border
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent, // Make AppBar transparent to show container color
                elevation: 0, // Remove shadow
                leadingWidth: size.width * 0.4,
                automaticallyImplyLeading: false,

                leading: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Image.asset('assets/images/app_bar_home.png', width: size.width * 0.05, height: size.height * 0.05),
                    ),
                    IconButton(
                      onPressed: () => Get.to(() => const ChildDashboardScreen())
                      ,
                      icon: Image.asset('assets/images/app_bar_profile.png', width: size.width * 0.05, height: size.height * 0.05),
                    ),
                    IconButton(
                      onPressed: () => Get.to(()=> CharacterSelectScreen()),
                      icon: Icon(Icons.accessibility, size: size.width * 0.06,color: Colors.orange, ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () => authController.logOut(),
                    icon: Image.asset('assets/images/app_bar_logout.png', width: size.width * 0.05, height: size.height * 0.05),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset('assets/images/numou_logo.png', width: size.width * 0.07, height: size.height * 0.07),
                  ),
                ],
              ),
            ),
          )
          ,


      floatingActionButton: GlowingFab(
        color: fabColor,
        child: FloatingActionButton.extended(
          backgroundColor: fabColor,
          elevation: 0,
          shape: const StadiumBorder(),
          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
          label: const Text('ابدأ الآن',
              style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          onPressed: () {
            final firstUnlocked = c.letters.firstWhere(
                  (s) => c.isUnlocked(s.id) ,
              orElse: () => c.letters.first,
            );
            c.select(firstUnlocked.id);
            Get.to(()=>LevelScreen());
          },
        ),
      ),

      body:
          SafeArea(
            child: Obx(() {
              // Rebuild when child/levels change
              final letters = c.letters;
              final _ = c.data.children.length; // force dependency
              return Stack(
                children: [

                  LevelMapWidget(

                    letters: letters,
                    statusOf: c.statusOf,
                    pointsOf: c.pointsOf,
                    onTapLetter: (id) {

                      if (c.isLocked(id)) {
                        Get.snackbar('مستوى مقفول', 'أكمل المستويات السابقة لفتح هذا الحرف',
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        c.select(id);
                        Get.to(()=>LevelScreen());
                      }
                    },
                    nodeSize: 72,
                    spacingY: 140,
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 120),
                  ),
                  Positioned(
                    right: 5,
                    top: 0,
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            final pts   = data.selectedChildPoints;       // earned so far
                            final total = data.totalPossiblePoints;       // 112
                            final prog  = data.selectedChildProgress01;   // 0..1

                            // If your ArabicProgressBar just shows a single text,
                            // embed the numbers in Arabic-friendly text:
                            final label = titleForPoints(pts, total); // or 'progress.total'.tr + ' $pts/$total'

                            return Column(
                              children: [
                               // SizedBox(height: size.height*0.01,),
                                SkillBadges(current: label),
                                SizedBox(height: size.height*0.005,),
                                ArabicProgressBar(
                                  progressValue: prog,   // 0..1
                                  levelText: label,
                                  points: pts,// Arabic label with numbers
                                ),
                              ],
                            );
                          }),
                          SizedBox(width: size.width*0.02,),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                size.width * 0.07,
                              ),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),

                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                size: size.width * 0.07,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),),
                ],
              );
            }),
          ),
        ),
    )
    );
  }


}

class GlowingFab extends StatefulWidget {
  const GlowingFab({super.key, required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  State<GlowingFab> createState() => _GlowingFabState();
}

class _GlowingFabState extends State<GlowingFab> {
  bool _up = true;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.35, end: _up ? 0.9 : 0.35),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeInOut,
      onEnd: () => setState(() => _up = !_up),
      builder: (ctx, v, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: widget.color.withOpacity(v * 0.9),
                  blurRadius: 22 + 26 * v, spreadRadius: 2 + 6 * v),
              BoxShadow(color: widget.color.withOpacity(v * 0.6),
                  blurRadius: 46 + 26 * v, spreadRadius: 10 + 10 * v),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
