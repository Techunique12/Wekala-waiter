import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class RegisterRowWidget extends StatelessWidget {
  final String title;
  final double sell;
  final double? expense;
  final bool showExpense;
  const RegisterRowWidget({
    super.key,
    required this.title,
    required this.sell,
    this.expense,
    this.showExpense = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title.tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: context.smallFont),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '$sell ${AppConstants.currency}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.smallFont),
            ),
          ),
          if (showExpense)
            Expanded(
              child: Text(
                expense != null ? '$expense ${AppConstants.currency}' : "--",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: context.smallFont),
              ),
            ),
        ],
      ),
    );
  }
}
