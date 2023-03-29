import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'map_is_loading.dart';

class Map extends StatefulWidget {
  final MapController mapController;
  final Function(bool) onMapIsReady;
  final double height;
  final bool trackMyPosition;
  final double initZoom;
  const Map(
      {Key? key,
      required this.mapController,
      required this.onMapIsReady,
      required this.height,
      required this.trackMyPosition,
      required this.initZoom})
      : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  MarkerIcon userLocationMarker = const MarkerIcon(
    icon: Icon(
      Icons.location_on,
      color: Colors.blue,
      size: 100,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: OSMFlutter(
        controller: widget.mapController,
        trackMyPosition: widget.trackMyPosition,
        maxZoomLevel: 18,
        //minZoomLevel: 8,
        initZoom: widget.initZoom,
        userLocationMarker: UserLocationMaker(
            personMarker: userLocationMarker,
            directionArrowMarker: userLocationMarker),
        androidHotReloadSupport: true,
        onMapIsReady: widget.onMapIsReady,
        mapIsLoading: const MapIsLoading(),
      ),
    );
  }
}
