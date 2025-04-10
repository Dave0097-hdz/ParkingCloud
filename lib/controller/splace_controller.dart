import 'package:get/get.dart';
import 'package:parkcloud/pages/LoginPage.dart';
//import 'package:parkcloud/pages/MapPage.dart';
//import 'package:parkcloud/pages/MapPage.dart';

class SplaceController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    pageHander();
  }

  void pageHander() async {
    Future.delayed(
      const Duration(seconds: 6),
      () {
        Get.offAll(() => LoginPage());
        //Get.offAll(() => MapPage()); // Utilizamos Get.offAll(() => MapPage()); en lugar de Get.offAllNamed("/map-page");
        update();
      }
    );
  }
}