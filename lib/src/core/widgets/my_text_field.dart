import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyTextField extends StatefulWidget {
  final String title;
  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final double? fieldWidth;
  final TextStyle titleStyle;
  final Color fillColor;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const MyTextField({
    super.key,
    required this.title,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 8,
    this.fieldWidth,
    this.titleStyle = AppTheme.h5,
    this.fillColor = const Color(0xFFEEEEEE),
    this.obscureText = false,
    this.controller,
    this.validator, // Tambahkan validator
    this.onChanged,
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
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppTheme.primaryColor,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (_controller.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear),
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
      children: [
        Text(widget.title, style: widget.titleStyle),
        SizedBox(
          width: widget.fieldWidth,
          child: TextField(
            controller: _controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(),
              hintText: widget.hint,
              filled: true,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: AppTheme.onDefaultColor),
              errorText: _errorText, // Tambahkan errorText
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
