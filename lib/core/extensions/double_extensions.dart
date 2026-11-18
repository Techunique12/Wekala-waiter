import 'package:get/get.dart';
import 'package:wekala_waiter/util/app_constants.dart';

extension DoubleBalanceExtension on double {
  String isBalanced(double other, {double tolerance = 0.01}) {
    return (this - other).abs() < tolerance == true
        ? 'balanced'.tr
        : '${'shortage'.tr} ${difference(other)} ${AppConstants.currency}';
  }

  double difference(double other) {
    return this - other;
  }
}
