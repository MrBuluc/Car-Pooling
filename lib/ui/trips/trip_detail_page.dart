import 'package:car_pooling/models/match/get_match_response.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/widgets/map_is_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TripDetailPage extends StatefulWidget {
  final GetMatchResponse getMatchResponse;
  const TripDetailPage({Key? key, required this.getMatchResponse})
      : super(key: key);

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  double west = 30.8203, south = 38.6769, east = 33.8558, north = 40.7537;

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
            SizedBox(
              height: size.height * .8,
              child: OSMFlutter(
                controller: mapController,
                trackMyPosition: trip.status! != Status.active,
                maxZoomLevel: 18,
                minZoomLevel: 8,
                initZoom: 13,
                userLocationMarker: UserLocationMaker(
                    personMarker: userLocationMarker,
                    directionArrowMarker: userLocationMarker),
                onMapIsReady: (ready) async {
                  await onMapIsReady(ready);
                },
                mapIsLoading: const MapIsLoading(),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> onMapIsReady(bool ready) async {
    if (ready) {
      mapController.limitAreaMap(
          BoundingBox(north: north, east: east, south: south, west: west));
      GeoPoint destinationGeoPoint = GeoPoint(
          latitude: double.parse(trip.destinationLat!),
          longitude: double.parse(trip.destinationLon!));
      if (trip.status != Status.active) {
        GeoPoint myLocationGeoPoint = await mapController.myLocation();
        await mapController.drawRoad(myLocationGeoPoint, destinationGeoPoint,
            roadOption: const RoadOption(roadColor: Colors.red, roadWidth: 10));
      } else {
        GeoPoint originGeoPoint =
            GeoPoint(latitude: trip.originLat!, longitude: trip.originLon!);
        mapController.changeLocation(originGeoPoint);
        mapController.drawRoad(originGeoPoint, destinationGeoPoint,
            roadOption: const RoadOption(roadColor: Colors.red, roadWidth: 10));
      }
    }
  }
}
