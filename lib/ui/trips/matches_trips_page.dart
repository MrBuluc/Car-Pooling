import 'package:car_pooling/models/trip.dart';
import 'package:flutter/material.dart';

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
      body: trips.isNotEmpty
          ? ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                Trip trip = trips[index];
                return Column(
                  children: [Text(trip.destination!)],
                );
              })
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Sorry, no passenger available yet.",
                    style: textStyle,
                  ),
                )
              ],
            ),
    ));
  }
}
