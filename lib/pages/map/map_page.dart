import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:metropass/controller/station_controller.dart';
import 'package:metropass/models/metro_intermediate_points.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/widgets/skeleton/atlas_skeleton.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMap _mapboxMap;
  final StationController _stationController = StationController();
  PointAnnotation? vehicleForward;
  PointAnnotation? vehicleBackward;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<StationModel>>(
        stream: _stationController.getStations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: AtlasSkeleton());
          }
          final stations = snapshot.data!;
          return MapWidget(
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(
                  stations.first.location.longitude,
                  stations.first.location.latitude,
                ),
              ),
              zoom: 13.5,
              pitch: 45,
            ),
            onMapCreated: (mapboxMap) async {
              _mapboxMap = mapboxMap;
              final bytes = (await rootBundle.load('assets/images/vehicle_run.png')).buffer.asUint8List();
              await _mapboxMap.style.addStyleImage(
                'vehicle_icon',
                1.0,
                MbxImage(data: bytes, width: 34, height: 34),
                false,
                const [],
                const [],
                null,
              );
              await _drawStationRoute(stations);
              await _addStationMarkers(stations);
              await _fitCameraToStationsAndIntermediatePoints(stations);
            },
          );
        },
      ),
    );
  }
  Future<void> _fitCameraToStationsAndIntermediatePoints(List<StationModel> stations) async {
    final allPoints = <Position>[
      for (final station in stations)
        Position(station.location.longitude, station.location.latitude),
      for (final entry in customIntermediatePoints.values)
        ...entry.map((p) => Position(p[1], p[0])),
    ];

    final lngs = allPoints.map((p) => p.lng).toList();
    final lats = allPoints.map((p) => p.lat).toList();

    final southwest = Position(
      lngs.reduce((a, b) => a < b ? a : b),
      lats.reduce((a, b) => a < b ? a : b),
    );
    final northeast = Position(
      lngs.reduce((a, b) => a > b ? a : b),
      lats.reduce((a, b) => a > b ? a : b),
    );

    final center = Position(
      (southwest.lng + northeast.lng) / 2,
      (southwest.lat + northeast.lat) / 2,
    );

    await _mapboxMap.flyTo(
      CameraOptions(
        center: Point(coordinates: center),
        zoom: 11.0,
      ),
      MapAnimationOptions(duration: 2000),
    );
  }

  Future<void> _addStationMarkers(List<StationModel> stations) async {
    final features = stations.map((station) => {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          station.location.longitude,
          station.location.latitude,
        ],
      },
      "properties": {
        "name": station.stationName,
      }
    }).toList();

    final geoJsonData = {
      "type": "FeatureCollection",
      "features": features,
    };

    await _mapboxMap.style.addSource(GeoJsonSource(
      id: 'stations_source',
      data: jsonEncode(geoJsonData),
    ));

    await _mapboxMap.style.addLayer(CircleLayer(
      id: 'station_circles',
      sourceId: 'stations_source',
      circleRadius: 6.0,
      circleColor: Colors.red.toARGB32(),
    ));

    await _mapboxMap.style.addLayer(SymbolLayer(
      id: 'station_labels',
      sourceId: 'stations_source',
      textField: '{name}',
      textSize: 12.0,
      textOffset: [0, 1.5],
      visibility: mapbox.Visibility.VISIBLE,
      minZoom: 13.5,
    ));
  }

  Future<void> _drawStationRoute(List<StationModel> stations) async {
    final coordinates = <List<double>>[];

    for (int i = 0; i < stations.length - 1; i++) {
      coordinates.add([
        stations[i].location.longitude,
        stations[i].location.latitude,
      ]);

      if (customIntermediatePoints.containsKey(i)) {
        coordinates.addAll(
          customIntermediatePoints[i]!.map((p) => [p[1], p[0]]),
        );
      }
    }

    coordinates.add([
      stations.last.location.longitude,
      stations.last.location.latitude,
    ]);

    final geoJsonData = {
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": coordinates,
      },
      "properties": {},
    };

    await _mapboxMap.style.addSource(GeoJsonSource(
      id: 'station_route_source',
      data: jsonEncode(geoJsonData),
    ));

    await _mapboxMap.style.addLayer(LineLayer(
      id: 'station_route_layer',
      sourceId: 'station_route_source',
      lineColor: Colors.blue.toARGB32(),
      lineWidth: 8.0,
    ));
  }
}