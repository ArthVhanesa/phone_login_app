import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetController extends GetxController {
  late final subscription;
  final isConnected = true.obs;

  @override
  void onInit() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.none) {
        log("Offline");
        isConnected.value = false;
        // Show dialog box for no Internet connection.
        Get.defaultDialog(
            title: '🚨 Alert!', content: Text('No Internet Connection. 📶'));
      } else {
        log("back to online");
      }
      log("$result");
    });
    super.onInit();
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }
}
