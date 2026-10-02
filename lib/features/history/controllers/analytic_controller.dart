// Controller to manage shifting between containers
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  var selectedIndex = 0.obs; // To keep track of the selected container

  // Method to change the selected index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
