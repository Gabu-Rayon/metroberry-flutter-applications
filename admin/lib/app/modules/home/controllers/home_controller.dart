import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentPageIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoading = true.obs;
  RxBool isHovered = false.obs;
  // final hoveredTransform = Matrix4.identity()
  //   ..translate(8, 0, 0)
  //   ..scale(1.2);

  void goToPage(int index) {
    currentPageIndex.value = index;
  }
}
