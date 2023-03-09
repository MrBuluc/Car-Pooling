import 'package:flutter/material.dart';

class MapIsLoading extends StatelessWidget {
  const MapIsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          Text("Map is Loading...")
        ],
      ),
    );
  }
}
