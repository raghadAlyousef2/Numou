
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/member_data_controller.dart';
import '../widgets/member_widget.dart';

class MembersScreen extends StatelessWidget {
  MembersScreen({super.key});

  // Find the MemberDataController
  final MemberDataController memberDataController =
      Get.put(MemberDataController());

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
            controller: memberDataController.searchController,
            style: const TextStyle(color: Color(0xFFC6C6C6)),
            decoration: InputDecoration(
              hintText: 'Search member name',
              hintStyle: const TextStyle(color: Color(0xFF828282)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFC6C6C6)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF828282)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              /*suffixIcon: Obx(()=> GrayscaleWidget(
                  isAbsorb:!Get.find<FirebaseDataController>().isOnline.value,
                  isGrayscale: false,
                  child: AddMemberButtonWidget())),*/
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Expanded(
              child: memberDataController.filteredMembers.isEmpty
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
                            'Looks like you have no members!',
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
                      itemCount: memberDataController.filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member =
                            memberDataController.filteredMembers[index];

                        return
                          MemberWidget(member: member, colorScheme: colorScheme, theme: theme, memberDataController: memberDataController);
                      }),
            ),
          ),
        ]),
      ),
    );
  }
}

