import 'package:car_pooling/models/trip.dart';
import 'package:flutter/material.dart';

class MyTripsPage extends StatefulWidget {
  final List<Trip> myTrips;
  const MyTripsPage({Key? key, required this.myTrips}) : super(key: key);

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  late List<Trip> myTrips;

  TextStyle textStyle = const TextStyle(fontSize: 20);

  SizedBox sizedBox = const SizedBox(
    height: 5,
  );

  @override
  void initState() {
    super.initState();
    myTrips = widget.myTrips;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Trips"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: ListView.builder(
              itemCount: myTrips.length,
              itemBuilder: (BuildContext context, int index) {
                Trip trip = myTrips[index];
                return GestureDetector(
                    child: Card(
                  color: Colors.grey.shade200,
                  child: Column(
                    children: [
                      Text(
                        trip.destination!,
                        style: textStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "From: ${trip.origin}",
                        style: textStyle,
                      ),
                      sizedBox,
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Status: ",
                              style: textStyle,
                            ),
                            Text(
                              trip.status!.name,
                              style: textStyle.copyWith(
                                  color: trip.status! == Status.ended
                                      ? Colors.red
                                      : Colors.green),
                            )
                          ],
                        ),
                      ),
                      Text(
                        "Driver's name: ${trip.driver}",
                        style: textStyle,
                      ),
                      sizedBox,
                      Text(
                        "Date: ${trip.createdAtToString()}",
                        style: textStyle,
                      )
                    ],
                  ),
                ));
              }),
        ),
      ),
    );
  }
}
