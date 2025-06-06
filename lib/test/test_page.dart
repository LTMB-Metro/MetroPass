import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:metropass/controller/mapbox_route_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMap _mapboxMap;
  late final MapboxRouteController _routeController;

  final Position origin = Position(106.7009, 10.7769);  // Bưu điện TP
  final Position destination = Position(106.6991, 10.7798); // Nhà thờ Đức Bà

  @override
  void initState() {
    super.initState();
    _routeController = MapboxRouteController(
      accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tuyến đường Mapbox")),
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point(coordinates: origin),
          zoom: 14.0,
        ),
        mapOptions: MapOptions(
          pixelRatio: MediaQuery.of(context).devicePixelRatio,
        ),
        styleUri: MapboxStyles.MAPBOX_STREETS,
        onMapCreated: (mapboxMap) async {
          _mapboxMap = mapboxMap;
          final route = await _routeController.getRouteCoordinates(
            origin: origin,
            destination: destination,
          );
          // await _routeController.drawRouteOnMap(
          //   map: _mapboxMap,
          //   route: route,
          // );
        },
      ),
    );
  }
}
