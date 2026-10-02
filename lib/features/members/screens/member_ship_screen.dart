
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/firebase_data_controller.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';
import '../controllers/member_ship_data_controller.dart';
import '../widgets/add_member_ship_button_widget.dart';
import '../widgets/member_ship_widget.dart';

class MembersShipScreen extends StatelessWidget {
  MembersShipScreen({super.key});

  // Find the MemberDataController
  final  MemberShipDataController memberShipDataController = Get.put( MemberShipDataController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextFormField(
            controller: memberShipDataController.searchController,
            style: const TextStyle(color: Color(0xFFC6C6C6)),
            decoration: InputDecoration(
              hintText: 'Search device ',
              hintStyle: const TextStyle(color: Color(0xFF828282)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFC6C6C6)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF828282)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: Obx(()=> GrayscaleWidget(
                  isAbsorb:!Get.find<FirebaseDataController>().isOnline.value,
                  isGrayscale: false,
                  child: AddMemberShipButtonWidget())),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
                () => Expanded(
              child: memberShipDataController.filteredMemberShips.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Whoops!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 36,
                        color: Color(0xFF6A6767),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Looks like you have no membership!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(0xFF6A6767),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                  itemCount: memberShipDataController.filteredMemberShips.length,
                  itemBuilder: (context, index) {
                    final memberShip =
                    memberShipDataController.filteredMemberShips[index];

                    return
                      MemberShipWidget(memberShip: memberShip, colorScheme: colorScheme, theme: theme, memberShipDataController: memberShipDataController);
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}

