// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/user/review.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/ui/profile/account_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatefulWidget {
  final List<Review> reviews;
  const ReviewsPage({Key? key, required this.reviews}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late List<Review> reviews;

  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    reviews = widget.reviews;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar("Reviews"),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: ListView.builder(
            itemCount: reviews.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Review review = reviews[index];
              return Column(
                children: [
                  Text(
                    "Review: ${review.review}",
                    style: textStyle,
                  ),
                  ProgressElevatedButton(
                      isProgress: isProgress,
                      text: "By: ${review.reviewerUsername}",
                      onPressed: () {
                        goToAccountPage(review.reviewerId!);
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    review.createdAtToString(),
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  divider
                ],
              );
            }),
      ),
    ));
  }

  Future goToAccountPage(String userId) async {
    setState(() {
      isProgress = true;
    });

    try {
      List userAndVehicle = await Provider.of<UserModel>(context, listen: false)
          .getProfile(userId);

      setState(() {
        isProgress = false;
      });

      goToPage(context,
          AccountPage(user: userAndVehicle[0], vehicle: userAndVehicle[1]));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);

      setState(() {
        isProgress = false;
      });
    }
  }
}
