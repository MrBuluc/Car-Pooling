// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/match/get_match_response.dart';
import 'package:car_pooling/models/match/post_match_response.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/ui/trips/trip_detail_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/trip.dart';

class MatchesPage extends StatefulWidget {
  final PostMatchResponse matchResponse;
  final Role role;
  const MatchesPage({Key? key, required this.matchResponse, required this.role})
      : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  late PostMatchResponse matchResponse;

  TextStyle textStyle = const TextStyle(fontSize: 20);

  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    matchResponse = widget.matchResponse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            matchResponse.result.isNotEmpty
                ? ListView.builder(
                    itemCount: matchResponse.result.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Trip matchedTrip = matchResponse.result[index];
                      return Column(
                        children: [
                          Text(
                            "Username: ${matchedTrip.username}",
                            style: textStyle,
                          ),
                          Text(
                            "Destination: ${matchedTrip.destination}",
                            style: textStyle,
                          ),
                          Text(
                            "Origin: ${matchedTrip.origin}",
                            style: textStyle,
                          ),
                          Text(
                            "Match rate: ${matchedTrip.matchRate}%",
                            style: textStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ProgressElevatedButton(
                              isProgress: isProgress,
                              text: widget.role == Role.driver
                                  ? "Offer ride"
                                  : "Request ride",
                              onPressed: () {
                                offerOrRequestRide(matchedTrip.id!);
                              }),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          )
                        ],
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        "No match found!",
                        style: textStyle,
                      ))
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ProgressElevatedButton(
                  isProgress: isProgress,
                  text: "End Ride",
                  backgroundColor: Colors.red,
                  onPressed: endRide,
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Future offerOrRequestRide(String matchId) async {
    setState(() {
      isProgress = true;
    });

    try {
      GetMatchResponse getMatchResponse =
          await Provider.of<UserModel>(context, listen: false)
              .getMatch(matchResponse.newTripId!, matchId);

      setState(() {
        isProgress = false;
      });

      goToPage(context, TripDetailPage(getMatchResponse: getMatchResponse));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);

      setState(() {
        isProgress = false;
      });
    }
  }

  Future endRide() async {
    setState(() {
      isProgress = true;
    });

    try {
      bool result = await Provider.of<UserModel>(context, listen: false)
          .endTrip(matchResponse.newTripId!);
      if (result) {
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 2);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
      setState(() {
        isProgress = false;
      });
    }
  }
}
