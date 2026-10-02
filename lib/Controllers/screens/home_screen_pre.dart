
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numou/screens/profile.dart';
import '../Controllers/firebase_data_controller.dart';
import '../features/history/screens/status_screen.dart';
import '../features/members/screens/member_ship_screen.dart';
import '../features/members/screens/members_screen.dart';
import '../features/notifications/controllers/firebase_push_notification_controller.dart';
import '../utiles/Widgets/gray_scale_widget.dart';
import 'dashboard.dart';

class HomeScreenPrev extends StatefulWidget {
    HomeScreenPrev({super.key});
  final  notificationController= Get.put(FirebasePushNotificationController());
  final  controller = Get.put(FirebaseDataController());

  @override
  State<HomeScreenPrev> createState() => _HomeScreenPrevState();
}

class _HomeScreenPrevState extends State<HomeScreenPrev> {
  int currentTab = 0;
  late List<Widget> screens;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard(key: UniqueKey());

  @override
  void initState() {
    super.initState();

    // Conditionally define screens based on user role
    screens = widget.controller.user.value.isOwner == 'true'
        ? [
      const Dashboard(),
      StatusScreen(),
      MembersScreen(),
      const ProfileScreen(),
    ]
        : [
      const Dashboard(),
      StatusScreen(), // Only show status for non-owners
       MembersShipScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Obx(
        ()=> GrayscaleWidget(
          isGrayscale: !widget.controller.isOnline.value,
          isAbsorb: false,
          child: Scaffold(
            body: PageStorage(bucket: bucket, child: currentScreen),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white70,
              notchMargin: 10,
              shape: const CircularNotchedRectangle(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(
                  ()=> Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Home tab
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = const Dashboard();
                                currentTab = 0;
                              });
                            },
                            minWidth: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    currentTab == 0
                                        ? Icons.home
                                        : Icons.home_outlined,
                                    color: currentTab == 0
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.surfaceDim,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Home',
                                    style: TextStyle(
                                      color: currentTab == 0
                                          ? theme.colorScheme.tertiary
                                          : theme.colorScheme.surfaceDim,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Status tab (displayed to everyone)
                         // if (widget.controller.user.value.isOwner == 'true')
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = StatusScreen();
                                currentTab = 1;
                              });
                            },
                            minWidth: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    currentTab == 1
                                        ? Icons.bar_chart_sharp
                                        : Icons.bar_chart_outlined,
                                    color: currentTab == 1
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.surfaceDim,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                      color: currentTab == 1
                                          ? theme.colorScheme.tertiary
                                          : theme.colorScheme.surfaceDim,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Member tab (only for owner)
                          widget.controller.user.value.isOwner == 'true'?
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  currentScreen = MembersScreen();
                                  currentTab = 2;
                                });
                              },
                              minWidth: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      currentTab == 2
                                          ? Icons.people_alt_rounded
                                          : Icons.people_alt_outlined,
                                      color: currentTab == 2
                                          ? theme.colorScheme.tertiary
                                          : theme.colorScheme.surfaceDim,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Members',
                                      style: TextStyle(
                                        color: currentTab == 2
                                            ? theme.colorScheme.tertiary
                                            : theme.colorScheme.surfaceDim,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                              :MaterialButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = MembersShipScreen();
                                currentTab = 2;
                              });
                            },
                            minWidth: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    currentTab == 2
                                        ? Icons.people_alt_rounded
                                        : Icons.people_alt_outlined,
                                    color: currentTab == 2
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.surfaceDim,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'MemberShip',
                                    style: TextStyle(
                                      color: currentTab == 2
                                          ? theme.colorScheme.tertiary
                                          : theme.colorScheme.surfaceDim,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Profile tab
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = const ProfileScreen();
                                currentTab = 3;
                              });
                            },
                            minWidth: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    currentTab == 3
                                        ? Icons.settings
                                        : Icons.settings_outlined,
                                    color: currentTab == 3
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.surfaceDim,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Profile',
                                    style: TextStyle(
                                      color: currentTab == 3
                                          ? theme.colorScheme.tertiary
                                          : theme.colorScheme.surfaceDim,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                ),
                ),
            )
          ,
            floatingActionButton: Obx(()=>currentTab == 0 && widget.controller.user.value.isOwner=='true'
                ? Obx(
                  () => GrayscaleWidget(
                    isAbsorb: !widget.controller.isOnline.value,
                    isGrayscale: false,
                    child: FloatingActionButton(
                                  elevation: 10,
                                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                                  ),
                                  backgroundColor: theme.colorScheme.surfaceDim,
                                  onPressed: () {
                    showAddDeviceDialog(context);
                                  },
                                  child: const Icon(Icons.add),
                                ),
                  ),
                )
                : const SizedBox.shrink(),), // Show FAB only when home screen is selected
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        ),
      ),
    );
  }

  void showAddDeviceDialog(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    TextEditingController deviceIdTextController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add New Device'),
        content: TextField(
          controller: deviceIdTextController,
          autofocus: true,
          decoration: InputDecoration(
            label: Text(
              'Enter Device Id',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              deviceIdTextController.text='';
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if(deviceIdTextController.text.isNotEmpty){
              widget.controller
                  .addNewDeviceToUser(deviceIdTextController.text.trim());}
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
