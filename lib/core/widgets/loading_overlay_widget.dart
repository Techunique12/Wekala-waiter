import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class LoadingOverlayWidget extends StatelessWidget {
  const LoadingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
