// ignore_for_file: sort_child_properties_last
// ignore_for_file: use_build_context_synchronously

import 'package:car_pooling/models/match/get_match_response.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/ui/trips/matched_trips_page.dart';
import 'package:car_pooling/ui/trips/matches_trips_page.dart';
import 'package:car_pooling/ui/trips/trip_requests_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class TripDetailPage extends StatefulWidget {
  final GetMatchResponse getMatchResponse;
  const TripDetailPage({Key? key, required this.getMatchResponse})
      : super(key: key);

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  //double west = 27.045, south = 35.93, east = 29.87, north = 37.928;

  late Size size;

  MapController mapController = MapController();

  MarkerIcon userLocationMarker = const MarkerIcon(
    icon: Icon(
      Icons.location_on,
      color: Colors.blue,
      size: 100,
    ),
  );

  late Trip trip;

  TextStyle buttonTextStyle = const TextStyle(fontSize: 20);

  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    trip = widget.getMatchResponse.trip!;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*Map(
              mapController: mapController,
              height: size.height * .46,
              trackMyPosition: trip.status! == Status.started,
              initZoom: 13,
              onMapIsReady: onMapIsReady,
            ),*/
            Container(
              height: size.height * .46,
              color: Colors.red,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 10, bottom: 10),
              child: Column(
                children: buildTripInfo(),
              ),
            ),
            ElevatedButton(
              child: Text(
                trip.role! == Role.driver
                    ? "Matched Passengers"
                    : "Matched Driver",
                style: buttonTextStyle,
              ),
              onPressed: () {
                goToPage(
                    context,
                    MatchedTripsPage(
                      role: trip.role!,
                      trips: widget.getMatchResponse.matched,
                      tripStatus: trip.status!,
                    ));
              },
            ),
            trip.status! == Status.started || trip.status! == Status.pending
                ? ElevatedButton(
                    child: Text(
                      trip.role! == Role.driver
                          ? "Available Passengers"
                          : "Available Drivers",
                      style: buttonTextStyle,
                    ),
                    onPressed: () {
                      goToPage(
                          context,
                          MatchesTripsPage(
                              role: trip.role!,
                              trips: widget.getMatchResponse.matches,
                              tripId: trip.id!));
                    },
                  )
                : Container(),
            widget.getMatchResponse.requests.isNotEmpty
                ? ElevatedButton(
                    child: Text(
                      "Requests",
                      style: buttonTextStyle,
                    ),
                    onPressed: () {
                      goToPage(
                          context,
                          TripsRequestPage(
                            requests: widget.getMatchResponse.requests,
                            tripId: trip.id!,
                          ));
                    },
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ProgressElevatedButton(
                      isProgress: isProgress,
                      text: "End Ride",
                      backgroundColor: Colors.red,
                      onPressed: endRide),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> onMapIsReady(bool ready) async {
    if (ready) {
      /*mapController.limitAreaMap(
          BoundingBox(north: north, east: east, south: south, west: west));*/
      GeoPoint destinationGeoPoint = GeoPoint(
          latitude: double.parse(trip.destinationLat!),
          longitude: double.parse(trip.destinationLon!));
      if (trip.status == Status.started) {
        GeoPoint myLocationGeoPoint = await mapController.myLocation();
        mapController.drawRoad(myLocationGeoPoint, destinationGeoPoint,
            roadOption: const RoadOption(roadColor: Colors.red, roadWidth: 10));
      } else {
        GeoPoint originGeoPoint =
            GeoPoint(latitude: trip.originLat!, longitude: trip.originLon!);
        mapController.changeLocation(originGeoPoint);
        mapController.drawRoad(originGeoPoint, destinationGeoPoint,
            roadOption: roadOption);
      }
    }
  }

  List<Widget> buildTripInfo() => [
        buildTripInfoRow("Date: ", trip.createdAtToString()),
        buildTripInfoRow("Destination: ", trip.destination!),
        buildTripInfoRow("From: ", trip.origin!),
        buildTripInfoRow("Driver's name: ", trip.driver.toString()),
        buildTripInfoRow("Role: ", trip.role!.name),
        buildTripInfoRow("Status: ", trip.status!.name)
      ];

  Widget buildTripInfoRow(String title, String info) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        Expanded(
          child: Text(
            info,
            style: const TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Future endRide() async {
    setState(() {
      isProgress = true;
    });

    try {
      bool result = await Provider.of<UserModel>(context, listen: false)
          .endTrip(trip.id!);
      if (result) {
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 3);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
      setState(() {
        isProgress = false;
      });
    }
  }
}
