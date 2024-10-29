import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool hasError;
  final String? errorMessage;
  final Function()? onVisibilityToggle;

  const CustomTextField({
    required this.labelText,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.hasError = false,
    this.errorMessage,
    this.onVisibilityToggle,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: widget.hasError ? Colors.red : Colors.grey,
              ),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                      if (widget.onVisibilityToggle != null) {
                        widget.onVisibilityToggle!();
                      }
                    },
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        if (widget.hasError && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 16, // Adjust the size as needed
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
