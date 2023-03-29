import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';

import '../ui/const.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({Key? key}) : super(key: key);

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Size size;

  TextEditingController reviewCnt = TextEditingController();

  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SimpleDialog(
      title: const Align(
        alignment: Alignment.topCenter,
        child: Text("Leave Review"),
      ),
      children: [
        Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.all(10),
            width: size.width,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Theme.of(context).primaryColor)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                controller: reviewCnt,
                maxLines: 5,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                    hintText: "We are looking forward to your review",
                    hintStyle: TextStyle(fontSize: 18),
                    border: InputBorder.none),
                style: textStyle,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProgressElevatedButton(
                  isProgress: isProgress,
                  text: "Cancel Review",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ProgressElevatedButton(
                isProgress: isProgress,
                text: "Give Review",
                backgroundColor: Colors.green,
                onPressed: () {},
              )
            ],
          ),
        )
      ],
    );
  }
}
