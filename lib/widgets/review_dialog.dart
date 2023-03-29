// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/user/review.dart';
import 'package:car_pooling/services/validator.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/const.dart';

class ReviewDialog extends StatefulWidget {
  final String? userId;
  final String? driverTripId;
  final String tripId;
  const ReviewDialog(
      {Key? key, this.userId, this.driverTripId, required this.tripId})
      : super(key: key);

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
                validator: (String? value) {
                  return Validator.emptyControl(value, "Must be a review");
                },
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
                onPressed: () {
                  giveReview();
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Future giveReview() async {
    setState(() {
      isProgress = true;
    });

    if (formKey.currentState!.validate()) {
      try {
        Review review = Review(review: reviewCnt.text, tripId: widget.tripId);
        late bool result = false;
        if (widget.driverTripId == null) {
          // Driver gives review
          review.userId = widget.userId!;
          result = await Provider.of<UserModel>(context, listen: false)
              .createReview(review);
        }
        if (result) {
          Navigator.pop(context);

          showSnackBar(context, "Successfully Reviwed 👍");
        }
      } catch (e) {
        showSnackBar(context, e.toString(), error: true);

        setState(() {
          isProgress = false;
        });
      }
    } else {
      setState(() {
        isProgress = false;
      });
    }
  }
}
