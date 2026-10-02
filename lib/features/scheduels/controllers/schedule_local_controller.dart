
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
class ScheduleLocalController  extends GetxController{
  static var instance= Get.find<ScheduleLocalController>();
  final _workManager=Workmanager();
  @override
  void onInit() {
     instance._workManager.initialize(taskHandlerCallback,isInDebugMode: true);
     super.onInit();
  }

  void registerPeriodTask(String taskId,String taskName ,Duration period){

  instance._workManager.registerPeriodicTask(taskId, taskName,tag: taskId,frequency: period );

  }
  void cancelTaskById(String taskId){
   instance._workManager.cancelByTag(taskId);
  }
  void cancelAllTask(){
   instance. _workManager.cancelAll();
  }

}


@pragma('vm:entry-point')
void taskHandlerCallback(){
  Workmanager().executeTask((taskName,inputData){
    //test
    if (kDebugMode) {
      print("tas executing :");
    }
    return Future.value(true);
  });
}