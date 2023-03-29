// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/match/get_match_response.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/ui/trips/trip_detail_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:car_pooling/widgets/view_profile_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripsRequestPage extends StatefulWidget {
  final List<Trip> requests;
  final String tripId;
  const TripsRequestPage(
      {Key? key, required this.requests, required this.tripId})
      : super(key: key);

  @override
  State<TripsRequestPage> createState() => _TripsRequestPageState();
}

class _TripsRequestPageState extends State<TripsRequestPage> {
  late List<Trip> requests;

  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    requests = widget.requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Match Requests"),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (BuildContext context, int index) {
              Trip trip = requests[index];
              return Column(
                children: [
                  Text(
                    trip.destination!,
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "From: ${trip.origin}",
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Username: ${trip.username}",
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProgressElevatedButton(
                          isProgress: isProgress,
                          text: "Accept ride",
                          onPressed: () {
                            acceptRide(trip.id!);
                          }),
                      ViewProfileButton(userId: trip.userId!)
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                  )
                ],
              );
            }),
      ),
    );
  }

  Future acceptRide(String matchId) async {
    setState(() {
      isProgress = true;
    });

    try {
      GetMatchResponse getMatchResponse =
          await Provider.of<UserModel>(context, listen: false)
              .acceptTrip(widget.tripId, matchId);

      setState(() {
        isProgress = false;
      });

      goToPage(
          context,
          TripDetailPage(
              getMatchResponse: getMatchResponse, popUntilMore: true));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }
  }
}
