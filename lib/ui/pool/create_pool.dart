import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';

class CreatePool extends StatefulWidget {
  const CreatePool({Key? key}) : super(key: key);

  @override
  State<CreatePool> createState() => _CreatePoolState();
}

class _CreatePoolState extends State<CreatePool> {
  late double startLat;
  late double startLon;
  double west = 32.5599, south = 39.7626, east = 33.5635, north = 40.6801;

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
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              TextFormField(
                controller: searchCnt,
                decoration: const InputDecoration(border: OutlineInputBorder()),
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
                        initZoom: 16,
                        userLocationMarker: UserLocationMaker(
                            personMarker: userLocationMarker,
                            directionArrowMarker: userLocationMarker),
                        onMapIsReady: (ready) async {
                          if (ready) {
                            GeoPoint geoPoint =
                                await mapController.myLocation();
                            startLat = geoPoint.latitude;
                            startLon = geoPoint.longitude;
                            mapController.limitAreaMap(BoundingBox(
                                north: north,
                                east: east,
                                south: south,
                                west: west));
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
              )
            ],
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
                .getNominatimPlaces(search);
        for (NominatimPlace nominatimPlace in nominatimPlaces) {
          nominatimPlace.d = (await distance2point(
                  GeoPoint(latitude: startLat, longitude: startLon),
                  GeoPoint(
                      latitude: double.parse(nominatimPlace.lat!),
                      longitude: double.parse(nominatimPlace.lon!)))) /
              1000;
        }
        setState(() {
          buildNominatimPlaceList = nominatimPlaces;
        });
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
          setState(() {
            buildNominatimPlaceList = [];
          });
          searchCnt.text = nominatimPlace.displayName!;
          await Future.delayed(const Duration(seconds: 3));
          await mapController.drawRoad(
              GeoPoint(latitude: startLat, longitude: startLon),
              GeoPoint(
                  latitude: double.parse(nominatimPlace.lat!),
                  longitude: double.parse(nominatimPlace.lon!)),
              roadOption:
                  const RoadOption(roadColor: Colors.red, roadWidth: 10));
        },
      ));
    }
    return children;
  }
}
