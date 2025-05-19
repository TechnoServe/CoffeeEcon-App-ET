import 'package:get/get.dart';

class NavController extends GetxController {
  final currentIndex = 0.obs;

  set tab(int index) => currentIndex.value = index;
}
