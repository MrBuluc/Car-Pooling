import 'package:flutter/material.dart';

class ProgressElevatedButton extends StatefulWidget {
  final bool isProgress;
  final String text;
  final void Function() onPressed;
  const ProgressElevatedButton(
      {Key? key,
      required this.isProgress,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  State<ProgressElevatedButton> createState() => _ProgressElevatedButtonState();
}

class _ProgressElevatedButtonState extends State<ProgressElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: widget.isProgress
          ? const CircularProgressIndicator()
          : Text(widget.text),
      onPressed: () {
        if (!widget.isProgress) {
          widget.onPressed();
        }
      },
    );
  }
}
