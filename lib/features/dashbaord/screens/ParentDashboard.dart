import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/features/dashbaord/screens/home_screen.dart';
import 'package:numou/features/dashbaord/screens/widgets/child_avatar.dart';
import 'package:numou/utiles/Widgets/gray_scale_widget.dart';
import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../authentication/controllers/auth_controller.dart';
import 'add_child_screen.dart';


class ParentDashboard extends StatelessWidget {
  ParentDashboard({super.key});
  final dataController = Get.put(NamouFirebaseDataController());

  final authController=Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return  Obx(
          ()=> GrayscaleWidget(
        isGrayscale: !dataController.isOnline.value,
        isAbsorb: false,

      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height*0.05 ), // Extra space if needed
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
                leadingWidth: size.width * 0.5,
                automaticallyImplyLeading: false,


                actions: [
                  IconButton(
                    onPressed: () => authController.logOut(),
                    icon: Image.asset('assets/images/app_bar_logout.png', width: size.width * 0.2, height: size.height * 0.2),
                  ),

                ],
              ),
            ),
          ),
        body:  Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill,
              ),
            ),
           child: Stack(
             children:[ Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         decoration: BoxDecoration(
                           color: const Color.fromRGBO(194, 237, 251, 0.7),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Text(
                           'parent.dashboard.start.title'.tr,
                           style: TextStyle(
                             fontSize: size.height * 0.035,
                             fontWeight: FontWeight.w700,
                             color: const Color(0xFF023047),
                           ),
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

                 // ---- avatar list ----
                //  SizedBox(height: size.height*0.20),
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
                        child:Column(
                    children: [


                      Obx(() {
                        final values = dataController.children.values.toList(growable: false);

                        if (values.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'لا يوجد أطفال حتى الآن',
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: const Color(0xFF5C6B73),
                                fontWeight: FontWeight.w600,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }

                        // 👇 Fixed-height scrolling area for avatars only
                        // 👇 Fixed-height scrolling area for avatars only
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                          child: SizedBox(
                            height: size.height * 0.30,
                            width: size.width *0.9,
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior().copyWith(overscroll: false),
                              child: Scrollbar(                     // <-- add this
                                thumbVisibility: true,              // show the handle
                                trackVisibility: true,
                                thickness: 6, // width of the thumb
                                radius: const Radius.circular(8), // rounded edges
                                // your green// show the track (desktop/web especially)
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 6,
                                    runSpacing: 12,
                                    children: values.map((s) {
                                      final selId = dataController.selectedChildId.value;
                                      final isSelected = selId == s.childId;
                                      return ChildAvatar(
                                        key: ValueKey(s.childId),
                                        name: s.name,
                                        assetPath: s.avatarPath ?? 'assets/avatars/1.png',
                                        selected: isSelected,
                                        onTap: () {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            dataController.selectChild(s.childId);
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                      }),

                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){

                              Get.to(()=>AddChildScreen());
                            },
                            child: Text(
                              'parent.dashboard.addChild'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.020,
                                color: Color.fromRGBO(255, 129, 3, 1),
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      // ---- Start button ----
                      Obx(() {
                        final canStart = dataController.selectedChildId.value != null;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36.0),
                          child: SizedBox(
                            width: 220,
                            child: ElevatedButton(
                              onPressed: canStart
                                  ? () {
                                final sid = dataController.selectedChildId.value!;
                                  Get.to(()=>HomeScreen());
                                // Get.toNamed('/learn', arguments: {'studentId': sid});
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF58CC02),
                                disabledBackgroundColor: const Color(0xFF9CD77C),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                shadowColor: const Color(0xFF58A700),
                              ),
                              child: const Text(
                                'ابدأ الآن',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),



                      // footer image (unchanged)

                    ],
                  ),
                    ),
                 ),
                 SizedBox(height: size.height * 0.10),

               ],
             ),
               Positioned(

                 bottom: 0,
                 left: 0,
                 child:  Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   Image.asset(
                     'assets/images/auth_character_1.png',
                     height: size.height * 0.20,
                     width: size.width * 0.32,
                     fit: BoxFit.fill,
                   ),
                 ],
               ),)
          ] )
          ),
        ),
    ));
  }

}
