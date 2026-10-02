import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';
import '../controllers/character_select_controller.dart';

class CharacterSelectScreen extends StatelessWidget {
  CharacterSelectScreen({super.key});
  final c = Get.put(CharacterSelectController());
  final data = Get.find<NamouFirebaseDataController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return
      Obx(
            ()=> GrayscaleWidget(
          isGrayscale: !data.isOnline.value,
          isAbsorb: false,

          child:
      Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('اختر شخصيتك'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Colors.orange),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // carousel (one page visible)
                PageView.builder(
                  controller: c.pageController,
                  itemCount: c.items.length,
                  onPageChanged: c.onPageChanged,
                  itemBuilder: (ctx, i) {
                    final preset = c.items[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie area (never cropped): full-width box, fixed height, contain fit
                        SizedBox(
                          width: size.width * 0.5,
                          height: size.height * 0.33,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            // ...
                            child: Lottie.asset(
                              preset.lottieAsset,
                              controller: c.lottieController,
                              fit: BoxFit.fill,
                              onLoaded: (comp) => c.onLottieLoadedFor(i, comp.duration),
                            )

// ...

                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          preset.arName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.w800,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 34),
                        Text(
                          'اسحب لليمين/اليسار لاختيار الشخصية – ستتكلم تلقائيًا',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // left arrow (only if there is a previous)
                Obx(() {
                  final show = c.currentIndex.value > 0;
                  if (!show) return const SizedBox.shrink();
                  return Positioned(
                    left: 6,
                    child: _ArrowButton(
                      icon: Icons.chevron_left,
                      onTap: c.prev,
                    ),
                  );
                }),

                // right arrow (only if there is a next)
                Obx(() {
                  final show = c.currentIndex.value < c.items.length - 1;
                  if (!show) return const SizedBox.shrink();
                  return Positioned(
                    right: 6,
                    child: _ArrowButton(
                      icon: Icons.chevron_right,
                      onTap: c.next,
                    ),
                  );
                }),
              ],
            ),
          ),

          // Save
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: c.save,
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ الاختيار'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              )),
        ],
      ),
    ),),);
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.85),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 34, color: Colors.orange),
        ),
      ),
    );
  }
}
