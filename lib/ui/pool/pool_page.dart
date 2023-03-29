// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/match/post_match_response.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/ui/matches/matches_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/map.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';

import '../../models/trip.dart';

class PoolPage extends StatefulWidget {
  final Role role;
  const PoolPage({Key? key, required this.role}) : super(key: key);

  @override
  State<PoolPage> createState() => _PoolPageState();
}

class _PoolPageState extends State<PoolPage> {
  double west = 27.045, south = 35.93, east = 29.87, north = 37.928;

  List<NominatimPlace> buildNominatimPlaceList = [];

  late Size size;

  TextEditingController searchCnt = TextEditingController();

  MapController mapController = MapController();

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
                  onChanged: (String search) {
                    getNominatimPlaces(search, context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Stack(
                    children: [
                      Map(
                        mapController: mapController,
                        onMapIsReady: onMapIsReady,
                        height: size.height * .76,
                        trackMyPosition: true,
                        initZoom: 5,
                      ),
                      /*SizedBox(
                        height: size.height * .76,
                        child: Container(
                          color: Colors.red,
                        ),
                      ),*/
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
                            ProgressElevatedButton(
                              isProgress: isProgress,
                              text: "Find Match",
                              onPressed: findMatch,
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

  Future getNominatimPlaces(String search, BuildContext context) async {
    if (search.length > 3) {
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
        showSnackBar(context, e.toString(), error: true);
      }
    }
  }

  onMapIsReady(bool ready) async {
    if (ready) {
      GeoPoint geoPoint = await mapController.myLocation();
      trip.originLat = geoPoint.latitude;
      trip.originLon = geoPoint.longitude;
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
        roadOption: roadOption);
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
      UserModel userModel = Provider.of<UserModel>(context, listen: false);
      trip.origin = (await userModel.getStartNominatimPlace(
              trip.originLat!, trip.originLon!))
          .displayName;
      PostMatchResponse matchResponse =
          await userModel.postMatch(widget.role, trip);
      goToPage(
          context,
          MatchesPage(
            matchResponse: matchResponse,
            role: widget.role,
          ));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }

    findMatchState(() {
      isProgress = false;
    });
  }
}
