// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/widgets/review_dialog.dart';
import 'package:car_pooling/widgets/view_profile_button.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class MatchedTripsPage extends StatefulWidget {
  final Role role;
  final List<Trip> trips;
  final Status tripStatus;
  final String tripId;
  const MatchedTripsPage(
      {Key? key,
      required this.role,
      required this.trips,
      required this.tripStatus,
      required this.tripId})
      : super(key: key);

  @override
  State<MatchedTripsPage> createState() => _MatchedTripsPageState();
}

class _MatchedTripsPageState extends State<MatchedTripsPage> {
  late List<Trip> trips;

  late Size size;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController reviewCnt = TextEditingController();

  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    trips = widget.trips;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: buildAppBar(
          widget.role == Role.driver ? "Matched Passengers" : "Matched Driver"),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              Trip trip = trips[index];
              return Column(
                children: [
                  Text(
                    trip.destination!,
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "From: ${trip.origin!}",
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Username: ${trip.username!}",
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Status: ${trip.status!.name}",
                    style: textStyle,
                  ),
                  ViewProfileButton(userId: trip.userId!),
                  widget.tripStatus == Status.ended
                      ? ElevatedButton(
                          child: Text(
                            "Leave Review",
                            style: textStyle,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => ReviewDialog(
                                    userId: trip.userId,
                                    tripId: widget.tripId,
                                    popUntilMore: false));
                          },
                        )
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                  )
                ],
              );
            }),
      ),
    ));
  }
}
