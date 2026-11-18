import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class CustomButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;

  final bool transparent;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  final double? height;
  final double? width;
  final double? fontSize;

  final Color? color;
  final Color? textColor;
  final Color? iconColor;

  final IconData? icon;
  final double? iconSize;

  final double radius;
  final FontWeight? fontWeight;

  final bool isLoading;
  final bool isBorder;
  final Color? borderColor;

  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? disabledIconColor;

  final bool iconAndTextVertical;

  const CustomButtonWidget({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.transparent = false,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.fontSize,
    this.color,
    this.textColor,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.radius = Dimensions.radiusDefault,
    this.fontWeight,
    this.isLoading = false,
    this.isBorder = false,
    this.borderColor,
    this.disabledColor,
    this.disabledTextColor,
    this.disabledIconColor,
    this.iconAndTextVertical = false,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDisabled = onPressed == null || isLoading;

    final backgroundColor = isDisabled
        ? disabledColor ?? colorScheme.surfaceContainerHighest
        : transparent
        ? Colors.transparent
        : color ?? colorScheme.primary;

    final foregroundColor = isDisabled
        ? disabledTextColor ?? colorScheme.onSurface.withValues(alpha: 0.38)
        : textColor ?? (transparent ? colorScheme.onSurface : Colors.white);

    final finalIconColor = isDisabled
        ? disabledIconColor ?? foregroundColor
        : iconColor ?? foregroundColor;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          fixedSize: width != null || height != null
              ? Size(width ?? double.infinity, height ?? double.infinity)
              : null,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: isBorder
                ? BorderSide(
                    color: isDisabled
                        ? colorScheme.outline.withValues(alpha: 0.15)
                        : borderColor ??
                              colorScheme.outline.withValues(alpha: 0.3),
                  )
                : BorderSide.none,
          ),
        ),
        child: Padding(
          padding:
              padding ??
              EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: isLoading && !iconAndTextVertical
              ? _buildLoading(context, foregroundColor)
              : _buildContent(context, foregroundColor, finalIconColor),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context, Color foregroundColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Text(
          'loading'.tr,
          style: TextStyle(
            color: foregroundColor,
            fontSize: fontSize ?? context.mediumFont,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    Color foregroundColor,
    Color iconColor,
  ) {
    final children = [
      if (icon != null) Icon(icon, color: iconColor, size: iconSize),

      if (icon != null)
        SizedBox(
          width: iconAndTextVertical ? 0 : Dimensions.paddingSizeSmall,
          height: iconAndTextVertical ? Dimensions.paddingSizeExtraSmall : 0,
        ),

      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          buttonText,
          maxLines: 1,
          style: TextStyle(
            color: foregroundColor,
            fontSize: fontSize ?? context.mediumFont,
            fontWeight: fontWeight,
          ),
        ),
      ),
    ];

    return Flex(
      direction: iconAndTextVertical ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
