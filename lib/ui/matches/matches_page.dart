import 'package:car_pooling/models/match_response.dart';
import 'package:flutter/material.dart';

import '../../models/trip.dart';

class MatchesPage extends StatefulWidget {
  final MatchResponse matchResponse;
  const MatchesPage({Key? key, required this.matchResponse}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  late MatchResponse matchResponse;

  TextStyle textStyle = const TextStyle(fontSize: 20);

  @override
  void initState() {
    super.initState();
    matchResponse = widget.matchResponse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: matchResponse.result.isNotEmpty
            ? ListView.builder(
                itemCount: matchResponse.result.length,
                itemBuilder: (context, index) {
                  Trip matchedTrip = matchResponse.result[index];
                  return Column(
                    children: [
                      Text(
                        "Username: ${matchedTrip.driver}",
                        style: textStyle,
                      ),
                      Text(
                        "Destination: ${matchedTrip.destination}",
                        style: textStyle,
                      ),
                      Text(
                        "Origin: ${matchedTrip.origin}",
                        style: textStyle,
                      ),
                      Text(
                        "Match rate: ${matchedTrip.matchRate}%",
                        style: textStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: const Text("Accept match"),
                        onPressed: () {},
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.grey,
                      )
                    ],
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    "No match found!",
                    style: textStyle,
                  ))
                ],
              ),
      ),
    ));
  }
}
