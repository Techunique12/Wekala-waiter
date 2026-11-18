import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class CalculatorDialog extends StatefulWidget {
  const CalculatorDialog({super.key});

  @override
  State<CalculatorDialog> createState() => _CalculatorDialogState();
}

class _CalculatorDialogState extends State<CalculatorDialog> {
  String display = '0';
  String expression = '';

  double? firstNumber;
  String? operator;

  bool shouldResetDisplay = false;

  // ============================================================
  // Calculator Logic
  // ============================================================

  void onButtonPressed(String button) {
    setState(() {
      if (button == 'C') {
        _clear();
        return;
      }

      if (button == '⌫') {
        _backspace();
        return;
      }

      if (['+', '-', '×', '÷', '%'].contains(button)) {
        _setOperator(button);
        return;
      }

      if (button == '=') {
        _calculate();
        return;
      }

      if (button == '.') {
        _addDecimal();
        return;
      }

      _addNumber(button);
    });
  }

  void _clear() {
    display = '0';
    expression = '';
    firstNumber = null;
    operator = null;
    shouldResetDisplay = false;
  }

  void _backspace() {
    if (display == 'Error') {
      _clear();
      return;
    }

    if (display.length > 1) {
      display = display.substring(0, display.length - 1);
    } else {
      display = '0';
    }

    _updateExpression();
  }

  void _setOperator(String newOperator) {
    final number = double.tryParse(display);

    if (number == null) return;

    // Example:
    // 10 + 5
    // If user presses another operator after 5,
    // calculate 10 + 5 first.
    if (operator != null && firstNumber != null) {
      _calculate();

      final result = double.tryParse(display);

      if (result == null) return;

      firstNumber = result;
    } else {
      firstNumber = number;
    }

    operator = newOperator;

    expression = '${_formatNumber(firstNumber!)} $newOperator';

    shouldResetDisplay = true;
  }

  void _addNumber(String number) {
    if (display == 'Error') {
      _clear();
    }

    if (shouldResetDisplay) {
      display = number;
      shouldResetDisplay = false;
    } else {
      if (display == '0') {
        display = number;
      } else {
        display += number;
      }
    }

    _updateExpression();
  }

  void _addDecimal() {
    if (display == 'Error') {
      _clear();
    }

    if (shouldResetDisplay) {
      display = '0.';
      shouldResetDisplay = false;
    } else if (!display.contains('.')) {
      display += '.';
    }

    _updateExpression();
  }

  void _updateExpression() {
    if (operator != null && firstNumber != null) {
      expression = '${_formatNumber(firstNumber!)} $operator $display';
    } else {
      expression = display;
    }
  }

  void _calculate() {
    if (firstNumber == null || operator == null) return;

    final secondNumber = double.tryParse(display);

    if (secondNumber == null) return;

    double result;

    switch (operator) {
      case '+':
        result = firstNumber! + secondNumber;
        break;

      case '-':
        result = firstNumber! - secondNumber;
        break;

      case '×':
        result = firstNumber! * secondNumber;
        break;

      case '÷':
        if (secondNumber == 0) {
          display = 'Error';
          expression = '';

          firstNumber = null;
          operator = null;
          shouldResetDisplay = true;

          return;
        }

        result = firstNumber! / secondNumber;
        break;

      case '%':
        result = firstNumber! * secondNumber / 100;
        break;

      default:
        return;
    }

    expression =
        '${_formatNumber(firstNumber!)} '
        '$operator '
        '${_formatNumber(secondNumber)} =';

    display = _formatNumber(result);

    firstNumber = null;
    operator = null;
    shouldResetDisplay = true;
  }

  String _formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }

    return number.toString();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.black : const Color(0xFFF2F2F7);

    final numberButtonColor = isDark ? const Color(0xFF333333) : Colors.white;

    final functionButtonColor = isDark
        ? const Color(0xFFA5A5A5)
        : const Color(0xFFD1D1D6);

    final primaryColor = theme.colorScheme.primary;

    final textColor = isDark ? Colors.white : Colors.black;

    final secondaryTextColor = isDark
        ? Colors.grey.shade500
        : Colors.grey.shade600;

    return Dialog(
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================
            // Header
            // ==================================================
            Row(
              children: [
                const SizedBox(width: 8),

                Text(
                  'calculator'.tr,
                  style: TextStyle(
                    color: textColor,
                    fontSize: context.largeFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: textColor),
                ),
              ],
            ),

            // ==================================================
            // Display
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Expression
                  SizedBox(
                    height: 25,
                    child: Text(
                      expression,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: secondaryTextColor, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Current value
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      display,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 52,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ==================================================
            // Buttons
            // ==================================================
            Directionality(
              textDirection: TextDirection.ltr,
              child: _buildButtons(
                numberButtonColor: numberButtonColor,
                functionButtonColor: functionButtonColor,
                operatorButtonColor: primaryColor,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons({
    required Color numberButtonColor,
    required Color functionButtonColor,
    required Color operatorButtonColor,
    required bool isDark,
  }) {
    const buttons = [
      ['C', '⌫', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['00', '0', '.', '='],
    ];

    return Column(
      children: buttons.map((row) {
        return Row(
          children: row.map((button) {
            return _buildButton(
              button,
              numberButtonColor: numberButtonColor,
              functionButtonColor: functionButtonColor,
              operatorButtonColor: operatorButtonColor,
              isDark: isDark,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildButton(
    String text, {
    required Color numberButtonColor,
    required Color functionButtonColor,
    required Color operatorButtonColor,
    required bool isDark,
  }) {
    final isOperator = ['÷', '×', '-', '+', '='].contains(text);

    final isFunction = ['C', '⌫', '%'].contains(text);

    final backgroundColor = isOperator
        ? operatorButtonColor
        : isFunction
        ? functionButtonColor
        : numberButtonColor;

    final textColor = isFunction
        ? (isDark ? Colors.black : Colors.black)
        : (isOperator || isDark ? Colors.white : Colors.black);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: AspectRatio(
          aspectRatio: 1,
          child: Material(
            color: backgroundColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => onButtonPressed(text),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
