import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class MyTextField extends StatefulWidget {
  final String title;
  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final double? fieldWidth;
  final TextStyle? titleStyle;
  final Color fillColor;
  final bool obscureText;
  final double gap;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  const MyTextField({
    super.key,
    required this.title,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 8,
    this.fieldWidth,
    this.titleStyle,
    this.fillColor = const Color(0xFFEEEEEE),
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.gap = 4,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.always,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController _controller;
  late bool _obscureText;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(_controller.text);
      });
    } else {
      setState(() {});
    }
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return MyIcon(
        icon: _obscureText ? Icons.visibility_off : Icons.visibility,
        backgroundColor: Colors.transparent,
        borderRadius: 0,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (_controller.text.isNotEmpty) {
      return MyIcon(
        icon: Icons.clear,
        backgroundColor: Colors.transparent,
        borderRadius: 0,
        iconColor: AppTheme.errorColor,
        onPressed: () {
          _controller.clear();
        },
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: widget.gap.r,
      children: [
        Text(widget.title, style: widget.titleStyle ?? AppTheme.h5),
        SizedBox(
          width: widget.fieldWidth?.w,
          child: TextFormField(
            style: AppTheme.text,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            keyboardType: widget.keyboardType,
            controller: _controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(),
              hintText: widget.hint,
              filled: true,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: AppTheme.onDefaultColor),
              errorText: _errorText,
            ),
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
          ),
        ),
      ],
    );
  }
}
