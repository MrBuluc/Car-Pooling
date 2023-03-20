import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';

class TripsRequestPage extends StatefulWidget {
  final List<Trip> requests;
  const TripsRequestPage({Key? key, required this.requests}) : super(key: key);

  @override
  State<TripsRequestPage> createState() => _TripsRequestPageState();
}

class _TripsRequestPageState extends State<TripsRequestPage> {
  late List<Trip> requests;

  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    requests = widget.requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Match Requests"),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (BuildContext context, int index) {
              Trip trip = requests[index];
              return Column(
                children: [
                  Text(
                    trip.destination!,
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "From: ${trip.origin}",
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Username: ${trip.username}",
                    style: textStyle,
                  ),
                  ProgressElevatedButton(
                      isProgress: isProgress,
                      text: "Accept ride",
                      onPressed: () {}),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                  )
                ],
              );
            }),
      ),
    );
  }
}
