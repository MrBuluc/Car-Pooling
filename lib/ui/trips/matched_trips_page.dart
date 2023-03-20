import 'package:car_pooling/models/trip.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class MatchedTripsPage extends StatefulWidget {
  final Role role;
  final List<Trip> trips;
  const MatchedTripsPage({Key? key, required this.role, required this.trips})
      : super(key: key);

  @override
  State<MatchedTripsPage> createState() => _MatchedTripsPageState();
}

class _MatchedTripsPageState extends State<MatchedTripsPage> {
  late List<Trip> trips;

  @override
  void initState() {
    super.initState();
    trips = widget.trips;
  }

  @override
  Widget build(BuildContext context) {
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
