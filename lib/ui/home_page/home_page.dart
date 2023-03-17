import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/ui/pool/pool_page.dart';
import 'package:car_pooling/ui/trips/my_trips_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              isProgress: isProgress, text: "My Trips", onPressed: getMyTrips)
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text(
                "Yolculuk Oluştur",
                style: textStyle,
              ),
              onPressed: () {
                goToPage(const PoolPage(
                  role: Role.driver,
                ));
              },
            ),
            ElevatedButton(
              child: Text(
                "Yolculuk Ara",
                style: textStyle,
              ),
              onPressed: () {
                goToPage(const PoolPage(role: Role.passenger));
              },
            )
          ],
        ),
      ),
    );
  }

  goToPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }

  Future getMyTrips() async {
    setState(() {
      isProgress = true;
    });

    try {
      List<Trip> myTrips =
          await Provider.of<UserModel>(context, listen: false).getMyTrips();
      goToPage(MyTripsPage(myTrips: myTrips));

      setState(() {
        isProgress = false;
      });
    } catch (e) {
      print("Hata: $e");
    }
  }
}
