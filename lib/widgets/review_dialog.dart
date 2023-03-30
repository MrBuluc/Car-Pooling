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
  final bool popUntilMore;
  const ReviewDialog(
      {Key? key,
      this.userId,
      this.driverTripId,
      required this.tripId,
      required this.popUntilMore})
      : super(key: key);

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
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
        Container(
          margin: const EdgeInsets.all(10),
          width: size.width,
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Theme.of(context).primaryColor)),
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
    popUntil(bool result) {
      if (result) {
        int count = 0, popUntil = widget.popUntilMore ? 4 : 3;
        Navigator.popUntil(context, (route) => count++ == popUntil);
      }
    }

    setState(() {
      isProgress = true;
    });

    try {
      UserModel userModel = Provider.of<UserModel>(context, listen: false);
      if (reviewCnt.text.isNotEmpty) {
        late bool result;
        Review review = Review(review: reviewCnt.text, tripId: widget.tripId);
        if (widget.driverTripId == null) {
          // Driver gives review
          review.userId = widget.userId!;
          result = await userModel.createReview(review);

          if (result) {
            Navigator.pop(context);

            showSnackBar(context, "Successfully Reviwed 👍");
          }
        } else {
          // Passenger gives review
          review.driverTripId = widget.driverTripId;
          result = await userModel.postEndTrip(review);
          popUntil(result);
        }
      } else {
        bool result = await userModel.endTrip(widget.tripId);

        popUntil(result);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);

      setState(() {
        isProgress = false;
      });
    }
  }
}
