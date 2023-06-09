// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/models/user/vehicle.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/ui/pool/pool_page.dart';
import 'package:car_pooling/ui/trips/my_trips_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle textStyle = const TextStyle(fontSize: 20);

  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ProgressElevatedButton(
            isProgress: isProgress,
            text: "My Trips",
            onPressed: getMyTrips,
            circularProgressIndicatorColor: Colors.black,
          ),
          ProgressElevatedButton(
              isProgress: isProgress,
              text: "Profile",
              onPressed: () {
                getVehicle();
              })
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text(
                "Create a Trip",
                style: textStyle,
              ),
              onPressed: () {
                goToPage(
                    context,
                    const PoolPage(
                      role: Role.driver,
                    ));
              },
            ),
            ElevatedButton(
              child: Text(
                "Search Trip",
                style: textStyle,
              ),
              onPressed: () {
                goToPage(context, const PoolPage(role: Role.passenger));
              },
            )
          ],
        ),
      ),
    );
  }

  Future getMyTrips() async {
    setState(() {
      isProgress = true;
    });

    try {
      List<Trip> myTrips =
          await Provider.of<UserModel>(context, listen: false).getMyTrips();
      goToPage(context, MyTripsPage(myTrips: myTrips));

      setState(() {
        isProgress = false;
      });
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }

    setState(() {
      isProgress = false;
    });
  }

  Future getVehicle() async {
    setState(() {
      isProgress = true;
    });

    try {
      Vehicle vehicle =
          await Provider.of<UserModel>(context, listen: false).getVehicle();

      setState(() {
        isProgress = false;
      });

      goToPage(context, ProfilePage(vehicle: vehicle));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);

      setState(() {
        isProgress = false;
      });
    }
  }
}
