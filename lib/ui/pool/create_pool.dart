import 'package:car_pooling/models/match_response.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';

import '../../models/trip.dart';

class CreatePool extends StatefulWidget {
  final Role role;
  const CreatePool({Key? key, required this.role}) : super(key: key);

  @override
  State<CreatePool> createState() => _CreatePoolState();
}

class _CreatePoolState extends State<CreatePool> {
  double west = 30.8203, south = 38.6769, east = 33.8558, north = 40.7537;

  List<NominatimPlace> buildNominatimPlaceList = [];

  late Size size;

  TextEditingController searchCnt = TextEditingController();

  MapController mapController = MapController();

  MarkerIcon userLocationMarker = const MarkerIcon(
    icon: Icon(
      Icons.location_on,
      color: Colors.blue,
      size: 100,
    ),
  );

  int count = 0;

  late StateSetter findMatchState;

  bool isProgress = false;

  Trip trip = Trip(route: []);

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
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              children: [
                TextFormField(
                  controller: searchCnt,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: getNominatimPlaces,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: size.height * .8,
                        child: OSMFlutter(
                          controller: mapController,
                          trackMyPosition: true,
                          maxZoomLevel: 18,
                          minZoomLevel: 10,
                          initZoom: 10,
                          userLocationMarker: UserLocationMaker(
                              personMarker: userLocationMarker,
                              directionArrowMarker: userLocationMarker),
                          onMapIsReady: (ready) async {
                            if (ready) {
                              GeoPoint geoPoint =
                                  await mapController.myLocation();
                              trip.originLat = geoPoint.latitude;
                              trip.originLon = geoPoint.longitude;
                              mapController.limitAreaMap(BoundingBox(
                                  north: north,
                                  east: east,
                                  south: south,
                                  west: west));
                              if (count == 0) {
                                trip.origin = (await Provider.of<UserModel>(
                                            context,
                                            listen: false)
                                        .getStartNominatimPlace(
                                            trip.originLat!, trip.originLon!))
                                    .displayName;
                                count++;
                              }
                            }
                          },
                          androidHotReloadSupport: true,
                          mapIsLoading: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                Text("Map is Loading...")
                              ],
                            ),
                          ),
                        ),
                      ),
                      buildNominatimPlaceList.isNotEmpty
                          ? Container(
                              height: size.height * .283,
                              color: Colors.white,
                              child: ListView(
                                shrinkWrap: true,
                                children: buildNominatimPlace(),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter rowState) {
                  findMatchState = rowState;
                  return trip.route!.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: isProgress
                                  ? const CircularProgressIndicator()
                                  : const Text("Find Match"),
                              onPressed: () {
                                if (!isProgress) {
                                  findMatch();
                                }
                              },
                            )
                          ],
                        )
                      : Container();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getNominatimPlaces(String search) async {
    if (search.length > 2) {
      try {
        List<NominatimPlace> nominatimPlaces =
            await Provider.of<UserModel>(context, listen: false)
                .getNominatimPlaces(search, west, south, east, north);
        for (NominatimPlace nominatimPlace in nominatimPlaces) {
          nominatimPlace.d = (await distance2point(
                  GeoPoint(
                      latitude: trip.originLat!, longitude: trip.originLon!),
                  GeoPoint(
                      latitude: double.parse(nominatimPlace.lat!),
                      longitude: double.parse(nominatimPlace.lon!)))) /
              1000;
        }
        if (nominatimPlaces.isNotEmpty) {
          setState(() {
            buildNominatimPlaceList = nominatimPlaces;
          });
        }
      } catch (e) {
        print("Hata: $e");
      }
    }
  }

  List<Widget> buildNominatimPlace() {
    List<Widget> children = [];
    for (NominatimPlace nominatimPlace in buildNominatimPlaceList) {
      children.add(GestureDetector(
        child: ListTile(
          leading: Column(
            children: [
              const Icon(Icons.location_on),
              Text("${nominatimPlace.d!.toStringAsFixed(2)} km")
            ],
          ),
          title: Text(nominatimPlace.displayName!),
        ),
        onTap: () async {
          trip.destination = nominatimPlace.displayName;
          trip.destinationLat = nominatimPlace.lat!;
          trip.destinationLon = nominatimPlace.lon!;
          await drawRoute(nominatimPlace);
        },
      ));
    }
    return children;
  }

  Future drawRoute(NominatimPlace nominatimPlace) async {
    setState(() {
      buildNominatimPlaceList = [];
    });
    searchCnt.text = nominatimPlace.displayName!;
    await Future.delayed(const Duration(seconds: 3));
    RoadInfo roadInfo = await mapController.drawRoad(
        GeoPoint(latitude: trip.originLat!, longitude: trip.originLon!),
        GeoPoint(
            latitude: double.parse(nominatimPlace.lat!),
            longitude: double.parse(nominatimPlace.lon!)),
        roadOption: const RoadOption(roadColor: Colors.red, roadWidth: 10));
    convertGeoPointToDoubleList(roadInfo.route);
    findMatchState(() {});
  }

  convertGeoPointToDoubleList(List<GeoPoint> geoPointList) {
    List<List<double>> route = [];
    for (GeoPoint geoPoint in geoPointList) {
      route.add([geoPoint.latitude, geoPoint.longitude]);
    }
    trip.route = route;
  }

  Future findMatch() async {
    findMatchState(() {
      isProgress = true;
    });

    try {
      MatchResponse matchResponse =
          await Provider.of<UserModel>(context, listen: false)
              .match(widget.role, trip);
      print(matchResponse);
    } catch (e) {
      print("Hata: $e");
    }

    findMatchState(() {
      isProgress = false;
    });
  }
}
