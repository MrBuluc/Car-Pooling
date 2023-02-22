import 'dart:math';

import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePool extends StatefulWidget {
  const CreatePool({Key? key}) : super(key: key);

  @override
  State<CreatePool> createState() => _CreatePoolState();
}

class _CreatePoolState extends State<CreatePool> {
  // hacettepe Teknokent
  double startLat = 39.863158548653175;
  double startLon = 32.737793283794964;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Stack(
            children: [
              TextFormField(
                decoration: InputDecoration(border: const OutlineInputBorder()),
                onChanged: getNominatimPlaces,
              ),
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
      } catch (e) {
        print("Hata: $e");
      }
    }
  }

  List<Widget> buildPlaces(List<NominatimPlace> nominatimPlaces) {
    List<Widget> places = [];
    for (NominatimPlace nominatimPlace in nominatimPlaces) {
      double d = distance(startLat.toString(), startLon.toString(),
          nominatimPlace.lat!, nominatimPlace.lon!);
    }
    return places;
  }

  double distance(String lat1, String lon1, String lat2, String lon2) {
    double lat1Double = double.parse(lat1);
    double lat2Double = double.parse(lat2);
    // radius of the earth in km
    int R = 6371;
    double dLat = (lat2Double - lat1Double) * (pi / 180);
    double dLon = (double.parse(lon2) - double.parse(lon1)) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Double * (pi / 180)) *
            cos(lat2Double * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }
}
