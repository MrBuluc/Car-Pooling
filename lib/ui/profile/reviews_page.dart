import 'package:car_pooling/models/user/review.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';

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
      appBar: buildAppBar("Reviews"),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          children: [
            ListView.builder(
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
                          onPressed: () {}),
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
                })
          ],
        ),
      ),
    ));
  }
}
