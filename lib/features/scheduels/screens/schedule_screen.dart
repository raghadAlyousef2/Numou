import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/water_heater_controller.dart';
import '../widgets/schedule_widget.dart';


class ScheduleScreen extends StatelessWidget {
   ScheduleScreen({super.key, required this.controller});
   WaterHeaterController controller;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: size.width * 0.08,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(size),
                  Expanded(
                    child: SizedBox(
                      width: size.width * 0.9,
                      height: size.height * 0.7,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.01),
                        child: Obx(
                          ()=> ListView.builder(
                            itemCount: controller.schedules.length,
                            itemBuilder: (context, index) {

                              return GestureDetector(onDoubleTap:(){
                                _showAddOrEditScheduleDialog(context, size,isNew:false,scheduleId: controller.schedules[index].value.id);
                              },child:  ScheduleWidget(controller: controller, schedule: controller.schedules[index],));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: FloatingActionButton(
                      elevation: 10,
                      backgroundColor: Colors.grey,
                      onPressed: () => _showAddOrEditScheduleDialog(context, size,isNew: true),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // Ensures it's fully circular
                      ),
                      child: Icon(
                        Icons.add,
                        size: size.width * 0.08,
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Schedule',
          style: TextStyle(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          'Schedule',
          style: TextStyle(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void  _showAddOrEditScheduleDialog(BuildContext context, Size size,{required isNew,String scheduleId=''}) {

    final now = DateTime.now();
    final currentHour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final currentMinute = now.minute;
    final currentAmPm = now.hour >= 12 ? 'PM' : 'AM';

    var selectedHour = currentHour.obs;
    var selectedMinute = currentMinute.obs;
    var selectedAmPm = currentAmPm.obs;

    final hourController = FixedExtentScrollController(initialItem: selectedHour.value - 0);
    final minuteController = FixedExtentScrollController(initialItem: selectedMinute.value);
    final amPmController = FixedExtentScrollController(initialItem: selectedAmPm.value == 'AM' ? 0 : 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      hourController.jumpToItem(selectedHour.value - 1);
      minuteController.jumpToItem(selectedMinute.value);
      amPmController.jumpToItem(selectedAmPm == 'AM' ? 0 : 1);
    });

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.1),
        ),
        contentPadding: const EdgeInsets.all(50),
        content: SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.7,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildWheel(hourController, selectedHour, size, 12),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: size.width * 0.09,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    _buildWheel(minuteController, selectedMinute, size, 60),
                    SizedBox(width: size.width * 0.02),
                    _buildAmPmWheel(amPmController, selectedAmPm, size),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDialogButton(
                      context,
                      size,
                      Icons.check,
                      'Save',
                      Colors.blue,
                          () async {
                        // final formattedTime = '${selectedHour.value.toString().padLeft(2, '0')}:${selectedMinute.value.toString().padLeft(2, '0')} ${selectedAmPm.value}';
                        // setState(() {
                        //   _times.add(formattedTime);
                        // });
                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                              barrierDismissible:
                              false, // Prevent closing the dialog by tapping outside
                            );
                        int hour= selectedAmPm.value=='PM'? selectedHour.value+12 :selectedHour.value;
                        int minutes=selectedMinute.value;
                       List<String>   daysOfWeek=[];
                        DateTime time=DateTime(0,0,0,hour,minutes);
                       if(  controller.validateTime(time, scheduleId)) {
                         if (isNew) {
                           //Todo add new schedule

                           await controller.addNewSchedule(time, daysOfWeek);
                         } else {
                           //Todo Update schedule
                           daysOfWeek = controller.schedules
                               .firstWhere((schedule) =>
                           schedule.value.id == scheduleId)
                               .value
                               .daysOfWeek;
                           await controller.updateSchedule(scheduleId, time,
                               daysOfWeek, true);
                         }
                         Get.back();
                       }
                       else{
                         Get.back();
                          //print('your selected time  ${controller.getFormattedDate(time)}  is lay in one of schedule 10 minuts change time plz');
                          Get.snackbar(
                            'Invalid Time', // Title
                            'Your selected time ${controller.getFormattedDate(time)} conflicts with an existing schedule. Please change the time by at least 10 minutes.', // Message
                            snackPosition: SnackPosition.BOTTOM, // Position at the bottom of the screen
                            backgroundColor: Colors.redAccent, // Background color
                            colorText: Colors.white, // Text color
                            borderRadius: 20,
                            duration: const Duration(seconds: 3), // Snackbar visibility duration
                          );
                          return;
                       }

                        Get.back();
                      },
                    ),
                    _buildDialogButton(
                      context,
                      size,
                      Icons.close,
                      'Cancel',
                      Colors.grey,
                          () => Get.back(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton(BuildContext context, Size size, IconData icon, String label, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _buildWheel(FixedExtentScrollController controller, RxInt selectedValue, Size size, int itemCount) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: size.height * 0.1,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Obx(() {
              final isSelected = index == selectedValue.value;
              return Container(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                decoration: isSelected
                    ? const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2.0, color: Colors.black),
                    bottom: BorderSide(width: 2.0, color: Colors.black),
                  ),
                )
                    : null,
                child: Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: size.width * 0.09,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            });
          },
          childCount: itemCount,
        ),
        onSelectedItemChanged: (index) {
          selectedValue.value = index;
        },
      ),
    );
  }

  Widget _buildAmPmWheel(FixedExtentScrollController controller, RxString selectedValue, Size size) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: size.height * 0.1,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Obx(() {
              final isSelected = index == (selectedValue.value == 'AM' ? 0 : 1);
              return Container(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                decoration: isSelected
                    ? const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2.0, color: Colors.black),
                    bottom: BorderSide(width: 2.0, color: Colors.black),
                  ),
                )
                    : null,
                child: Center(
                  child: Text(
                    index == 0 ? 'AM' : 'PM',
                    style: TextStyle(
                      fontSize: size.width * 0.09,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            });
          },
          childCount: 2,
        ),
        onSelectedItemChanged: (index) {
          selectedValue.value = index == 0 ? 'AM' : 'PM';
        },
      ),
    );
  }




}


