import 'package:car_pooling/ui/const.dart';
import 'package:flutter/material.dart';

class ProgressElevatedButton extends StatefulWidget {
  final bool isProgress;
  final String text;
  final Color? backgroundColor;
  final Color? circularProgressIndicatorColor;
  final void Function() onPressed;
  const ProgressElevatedButton(
      {Key? key,
      required this.isProgress,
      required this.text,
      this.backgroundColor,
      required this.onPressed,
      this.circularProgressIndicatorColor})
      : super(key: key);

  @override
  State<ProgressElevatedButton> createState() => _ProgressElevatedButtonState();
}

class _ProgressElevatedButtonState extends State<ProgressElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: widget.backgroundColor),
      child: widget.isProgress
          ? CircularProgressIndicator(
              color: widget.circularProgressIndicatorColor,
            )
          : Text(
              widget.text,
              style: textStyle,
            ),
      onPressed: () {
        if (!widget.isProgress) {
          widget.onPressed();
        }
      },
    );
  }
}
