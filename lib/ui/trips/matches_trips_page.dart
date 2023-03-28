// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/match/get_match_response.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:car_pooling/widgets/view_profile_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'trip_detail_page.dart';

class MatchesTripsPage extends StatefulWidget {
  final Role role;
  final List<Trip> trips;
  final String tripId;
  const MatchesTripsPage(
      {Key? key, required this.role, required this.trips, required this.tripId})
      : super(key: key);

  @override
  State<MatchesTripsPage> createState() => _MatchesTripsPageState();
}

class _MatchesTripsPageState extends State<MatchesTripsPage> {
  late List<Trip> trips;

  TextStyle textStyle = const TextStyle(fontSize: 20);

  bool isProgress = false;

  SizedBox sizedBox = const SizedBox(height: 5);

  @override
  void initState() {
    super.initState();
    trips = widget.trips;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.role == Role.driver
            ? "Available Passengers"
            : "Available Drivers"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: trips.isNotEmpty
            ? ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  Trip trip = trips[index];
                  return Column(
                    children: [
                      Text(
                        trip.destination!,
                        style: textStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      sizedBox,
                      Text(
                        "From: ${trip.origin}",
                        style: textStyle,
                      ),
                      sizedBox,
                      Text(
                        "Username: ${trip.username}",
                        style: textStyle,
                      ),
                      sizedBox,
                      Text(
                        "Match Rate: ${trip.matchRate}",
                        style: textStyle,
                      ),
                      sizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ProgressElevatedButton(
                              isProgress: isProgress,
                              text: widget.role == Role.passenger
                                  ? "Request ride"
                                  : "Offer ride",
                              onPressed: () {
                                requestOrOfferRide(trip.id!);
                              }),
                          ViewProfileButton(userId: trip.userId!)
                        ],
                      ),
                      sizedBox,
                      const Divider(
                        height: 1,
                        color: Colors.grey,
                      )
                    ],
                  );
                })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      widget.role == Role.driver
                          ? "Sorry, no passenger available yet."
                          : "Sorry, no driver available yet.",
                      style: textStyle,
                    ),
                  )
                ],
              ),
      ),
    ));
  }

  Future requestOrOfferRide(String matchId) async {
    setState(() {
      isProgress = true;
    });

    try {
      GetMatchResponse getMatchResponse =
          await Provider.of<UserModel>(context, listen: false)
              .getMatch(widget.tripId, matchId);

      setState(() {
        isProgress = false;
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TripDetailPage(getMatchResponse: getMatchResponse),
      ));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);

      setState(() {
        isProgress = false;
      });
    }
  }
}
