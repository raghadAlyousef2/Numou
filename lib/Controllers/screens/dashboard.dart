
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/firebase_data_controller.dart';
import '../features/authentication/controllers/auth_controller_pre.dart';
import '../utiles/Constant/strings.dart';
import '../utiles/Widgets/Header_widget.dart';
import '../utiles/Widgets/water_heater_widget.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});



  @override
  Widget build(BuildContext context) {
    var controller=Get.find<FirebaseDataController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePageAppBareTitle),
          centerTitle: true,
          leading: Obx(()=> controller.isOnline.value? const Icon(Icons.wifi,color: Colors.green,):const Icon(Icons.signal_wifi_connected_no_internet_4)),
          actions: [
            TextButton(
                onPressed: () {
                  AuthControllerPre.instance.logOut();
                },
                child: const Icon(
                  Icons.logout,
                  size: 30,
                ))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const header(),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50.0),
                    child: Text(
                      DeviceText,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Obx(
                    (){

                      return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0 ,vertical: 20),
                    child:
                    controller.user.value.devicesIds.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                         controller.user.value.isOwner=='true'? 'No devices configured yet ':'Send MemberShip Request ',
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )

                        :controller.user.value.devices.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Number of columns
                                    crossAxisSpacing:
                                        20, // Horizontal space between items
                                    mainAxisSpacing:
                                        20, // Vertical space between items
                                    childAspectRatio: 1.1),
                            itemCount: controller.user.value.devices.length,
                            itemBuilder: (context, index) {
                              int row = index ~/ 2;
                              int column = index % 2;

                              // Determine the color based on the binary pattern
                              Color color = (row % 2 == 0)
                                  ? (column == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface)
                                  : (column == 0
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.primary);

                              Color textColor = (row % 2 == 0)
                                  ? (column == 0
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.tertiary)
                                  : (column == 0
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Theme.of(context).colorScheme.surface);

                              return WaterHeater(
                                device:controller.user.value.devices[index],
                                color: color,
                                textColor: textColor,
                                swipDirection:column==0?'left':'right',
                              );
                            })
                        : controller.user.value.devicesIds.isNotEmpty && controller.isOnline.value==false?const Center(child: Text('No Internet Check Connection'),):
                    const Center(child: SizedBox( width: 30, child: CircularProgressIndicator()),)
                  );}
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
