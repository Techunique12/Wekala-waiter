import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;

  final int maxLines;
  final int? maxLength;

  final TextCapitalization textCapitalization;

  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;

  final Color? prefixIconColor;
  final Color? suffixIconColor;

  final double? fontSize;
  final double? labelFontSize;
  final double? hintFontSize;

  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  final double borderRadius;

  final EdgeInsetsGeometry? contentPadding;

  final String? Function(String?)? validator;

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;

  final List<TextInputFormatter>? inputFormatters;

  final bool showBorder;
  final bool required;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.prefixIconColor,
    this.suffixIconColor,
    this.fontSize,
    this.labelFontSize,
    this.hintFontSize,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius = Dimensions.radiusLarge,
    this.contentPadding,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.inputFormatters,
    this.showBorder = true,
    this.required = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderColor =
        widget.borderColor ?? theme.disabledColor.withValues(alpha: 0.5);

    final focusedBorderColor = widget.focusedBorderColor ?? theme.primaryColor;

    final errorBorderColor = widget.errorBorderColor ?? theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.label,
                  style: TextStyle(
                    fontSize: widget.labelFontSize ?? context.mediumFont,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (widget.required)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: widget.labelFontSize ?? context.mediumFont,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),
        ],

        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,

          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,

          obscureText: _obscureText,

          enabled: widget.enabled,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,

          maxLines: widget.obscureText ? 1 : widget.maxLines,

          maxLength: widget.maxLength,

          textCapitalization: widget.textCapitalization,

          validator: widget.validator,

          inputFormatters: widget.inputFormatters,

          style: TextStyle(
            fontSize: widget.fontSize ?? context.mediumFont,
            color: theme.textTheme.bodyLarge?.color,
          ),

          cursorColor: theme.primaryColor,

          decoration: InputDecoration(
            hintText: widget.hint,

            hintStyle: TextStyle(
              fontSize: widget.hintFontSize ?? context.mediumFont,
              color: theme.disabledColor,
            ),

            filled: true,

            fillColor:
                widget.fillColor ??
                theme.inputDecorationTheme.fillColor ??
                theme.cardColor,

            isDense: true,

            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            prefixIcon: _buildPrefixIcon(theme),

            suffixIcon: _buildSuffixIcon(theme),

            border: _buildBorder(borderColor, widget.showBorder),

            enabledBorder: _buildBorder(borderColor, widget.showBorder),

            focusedBorder: _buildBorder(focusedBorderColor, widget.showBorder),

            errorBorder: _buildBorder(errorBorderColor, widget.showBorder),

            focusedErrorBorder: _buildBorder(
              errorBorderColor,
              widget.showBorder,
            ),

            errorStyle: TextStyle(
              fontSize: context.smallFont,
              color: theme.colorScheme.error,
            ),
          ),

          onTap: widget.onTap,

          onChanged: widget.onChanged,

          onEditingComplete: widget.onEditingComplete,

          onFieldSubmitted: (value) {
            if (widget.nextFocus != null) {
              FocusScope.of(context).requestFocus(widget.nextFocus);
            } else {
              widget.onSubmitted?.call(value);
            }
          },

          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }

  Widget? _buildPrefixIcon(ThemeData theme) {
    if (widget.prefixWidget != null) {
      return widget.prefixWidget;
    }

    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        size: context.iconSize,
        color:
            widget.prefixIconColor ??
            theme.disabledColor.withValues(alpha: 0.5),
      );
    }

    return null;
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    if (widget.obscureText) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color:
              widget.suffixIconColor ??
              theme.disabledColor.withValues(alpha: 0.5),
        ),
      );
    }

    return widget.suffixWidget;
  }

  OutlineInputBorder _buildBorder(Color color, bool showBorder) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: color,
        width: showBorder ? 1 : 0,
        style: showBorder ? BorderStyle.solid : BorderStyle.none,
      ),
    );
  }
}
