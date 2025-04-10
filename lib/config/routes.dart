import 'package:get/get.dart';
import 'package:parkcloud/pages/MapPage.dart';
import 'package:parkcloud/pages/profile_page/profile_screen.dart';
import 'package:parkcloud/pages/homepage/home_page.dart';

var pages = [
  GetPage(
    name: "/homepage", 
    page: () => HomePage(slotId: Get.parameters['slotId'] ?? '', slotName: 'nombre'),
    transition: Transition.rightToLeft,
    ),
  GetPage(
    name: "/edit-profile",
    page: () => EditProfile(), 
    transition: Transition.rightToLeft,
    ),
  GetPage(
    name: "/map-page", 
    page: () => MapPage(),
    transition: Transition.rightToLeft,
    ),
];