import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:metropass/controllers/mapbox_route_controller.dart';
import 'package:metropass/models/metro_intermediate_points.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/themes/colors/colors.dart';

class MapContrller {
  final MapboxRouteController _routeController = MapboxRouteController(accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN']!);

  Future<void> fitCameraToStationsAndIntermediatePoints(List<StationModel> stations, MapboxMap mapboxMap) async {
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

    await mapboxMap.flyTo(
      CameraOptions(
        center: Point(coordinates: center),
        zoom: 11.0,
      ),
      MapAnimationOptions(duration: 2000),
    );
  }
  Future<void> addStationMarkers(List<StationModel> stations, MapboxMap mapboxMap) async {
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

    await mapboxMap.style.addSource(GeoJsonSource(
      id: 'stations_source',
      data: jsonEncode(geoJsonData),
    ));

    await mapboxMap.style.addLayer(CircleLayer(
      id: 'station_circles',
      sourceId: 'stations_source',
      circleRadius: 6.0,
      circleColor: Colors.red.toARGB32(),
    ));

    await mapboxMap.style.addLayer(SymbolLayer(
      id: 'station_labels',
      sourceId: 'stations_source',
      textField: '{name}',
      textSize: 12.0,
      textOffset: [0, 1.5],
      visibility: mapbox.Visibility.VISIBLE,
      minZoom: 13.5,
    ));
  }
  Future<void> handleSearchAndDrawRoute(
    List<StationModel> stations, 
    MapboxMap mapboxMap, 
    TextEditingController startController, 
    TextEditingController endController,
    PointAnnotationManager annotationManager
  ) async {
    final startText = startController.text.trim();
    final endText = endController.text.trim();

    if (startText.isEmpty || endText.isEmpty) return;

    final startCoord = await _routeController.getCoordinatesFromAddress(startText);
    final endCoord = await _routeController.getCoordinatesFromAddress(endText);

    if (startCoord == null || endCoord == null) {
      print('Không tìm thấy tọa độ từ địa chỉ');
      return;
    }
    await annotationManager.deleteAll();
    await addMarker(
      startCoord,
      'Vị trí xuất phát',
      annotationManager
    );
    await addMarker(
      endCoord,
      'Vị trí điểm đến',
      annotationManager
    );
    final startStation = _findNearestStation(startCoord, stations);
    final endStation = _findNearestStation(endCoord, stations);
    final startIndex = stations.indexOf(startStation);
    final endIndex = stations.indexOf(endStation);

    await addMarker(
      Position(startStation.location.longitude, startStation.location.latitude),
      '',
      annotationManager
    );
    await addMarker(
      Position(endStation.location.longitude, endStation.location.latitude),
      '',
      annotationManager
    );
    final origin = Position(startStation.location.longitude, startStation.location.latitude);
    final destination = Position(endStation.location.longitude, endStation.location.latitude);

    final routeFromInputToStartStation = await _routeController.getRouteCoordinates(
      origin: startCoord,
      destination: origin, 
    );
    final routeFromEndToEndStation = await _routeController.getRouteCoordinates(
      origin: endCoord,
      destination: destination, 
    );

    await _routeController.drawCustomRouteOnMap(
      map: mapboxMap,
      route: routeFromInputToStartStation,
      color: Colors.blue,
      sourceId: 'input_to_start_source',
      layerId: 'input_to_start_layer',
    );

    await _routeController.drawCustomRouteOnMap(
      map: mapboxMap,
      route: routeFromEndToEndStation,
      color: Colors.blue,
      sourceId: 'input_to_end_source',
      layerId: 'input_to_end_layer',
    );

    await drawStationRoute(
      stations: stations,
      map: mapboxMap,
      color: Colors.blue,
      sourceId: 'highlight_segment_source',
      layerId: 'highlight_segment_layer',
      indexStart: startIndex,
      indexEnd: endIndex
    );
    await addCircleMarker(
      id: 'input_start',
      position: startCoord,
      color: Color(MyColor.pr8),
      radius: 6,
      mapboxMap: mapboxMap
    );

    await addCircleMarker(
      id: 'input_end',
      position: endCoord,
      color: Color(MyColor.pr8),
      radius: 6,
      mapboxMap: mapboxMap
    );

    await addCircleMarker(
      id: 'nearest_start',
      position: Position(
        startStation.location.longitude,
        startStation.location.latitude,
      ),
      color: Color(MyColor.pr8),
      radius: 6,
      mapboxMap: mapboxMap
    );

    await addCircleMarker(
      id: 'nearest_end',
      position: Position(
        endStation.location.longitude,
        endStation.location.latitude,
      ),
      color: Color(MyColor.pr8),
      radius: 6,
      mapboxMap: mapboxMap
    );
  }

  Future<void> drawStationRoute({
    required List<StationModel> stations,
    required MapboxMap map,
    required Color color,
    required String sourceId,
    required String layerId,
    int? indexStart,
    int? indexEnd,
  }) async {
    final style = map.style;
    final coordinates = <List<double>>[];

    int start = indexStart ?? 0;
    int end = indexEnd ?? stations.length - 1;

    if (start <= end) {
      for (int i = start; i < end; i++) {
        coordinates.add([stations[i].location.longitude, stations[i].location.latitude]);
        if (customIntermediatePoints.containsKey(i)) {
          coordinates.addAll(customIntermediatePoints[i]!.map((p) => [p[1], p[0]]));
        }
      }
      coordinates.add([stations[end].location.longitude, stations[end].location.latitude]);
    } else {
      for (int i = start; i > end; i--) {
        coordinates.add([stations[i].location.longitude, stations[i].location.latitude]);
        final key = i - 1;
        if (customIntermediatePoints.containsKey(key)) {
          coordinates.addAll(customIntermediatePoints[key]!.reversed.map((p) => [p[1], p[0]]));
        }
      }
      coordinates.add([stations[end].location.longitude, stations[end].location.latitude]);
    }

    final geoJsonData = {
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": coordinates,
      },
      "properties": {},
    };

    try {
      if (await style.styleLayerExists(layerId)) {
        await style.removeStyleLayer(layerId);
      }
      if (await style.styleLayerExists('${layerId}_arrow_text')) {
        await style.removeStyleLayer('${layerId}_arrow_text');
      }
      if (await style.styleSourceExists(sourceId)) {
        await style.removeStyleSource(sourceId);
      }

      await style.addSource(GeoJsonSource(id: sourceId, data: jsonEncode(geoJsonData)));

      await style.addLayer(LineLayer(
        id: layerId,
        sourceId: sourceId,
        lineColor: color.toARGB32(),
        lineWidth: 8.0,
      ));

      await style.addLayer(SymbolLayer(
        id: '${layerId}_arrow_text',
        sourceId: sourceId,
        textField: '➤',
        textSize: 14.0,
        symbolSpacing: 50,
        symbolPlacement: SymbolPlacement.LINE,
        textRotationAlignment: TextRotationAlignment.MAP,
        textKeepUpright: false,
        textAllowOverlap: true,
        textIgnorePlacement: true,
      ));
    } catch (e) {
      print("⚠️ drawStationRoute error: $e");
    }
  }
  StationModel _findNearestStation(Position input, List<StationModel> stations) {
    final copied = [...stations]; 
    copied.sort((a, b) {
      final d1 = _calcDistance(input, _geoPointToPosition(a.location));
      final d2 = _calcDistance(input, _geoPointToPosition(b.location));
      return d1.compareTo(d2);
    });
    return copied.first;
  }
  Position _geoPointToPosition(GeoPoint geoPoint) {
    return Position(geoPoint.longitude, geoPoint.latitude);
  }
  double _calcDistance(Position a, Position b) {
    final dx = a.lng - b.lng;
    final dy = a.lat - b.lat;
    return (dx * dx + dy * dy).toDouble();
  }
  Future<void> addMarker(Position position, String title, PointAnnotationManager annotationManager) async {
    await annotationManager.create(PointAnnotationOptions(
      geometry: Point(coordinates: position),
      textField: title,
      textSize: 12.0,
      textOffset: [0, 1.5],
      iconSize: 1.0,
      iconImage: "marker-15",
    ));
  }
  Future<List<String>> getPlaceSuggestions(String query) async {
    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(query)}.json'
      '?access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}'
      '&autocomplete=true'
      '&limit=5'
      '&language=vi'
      '&types=poi,address,place,locality,neighborhood'
      '&bbox=106.3656,10.6958,106.9658,11.1255'
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final features = data['features'] as List;

    return features.map((f) => f['place_name'].toString()).toList();
  }
  Future<void> addCircleMarker({
    required String id,
    required Position position,
    required Color color,
    required double radius,
    required MapboxMap mapboxMap
  }) async {
    final sourceId = '${id}_source';
    final layerId = '${id}_layer';
    final geoJson = jsonEncode({
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [position.lng, position.lat]
          }
        }
      ]
    });
    final style = mapboxMap.style;
    try {
      await style.removeStyleLayer(layerId);
    } catch (_) {}
    try {
      await style.removeStyleSource(sourceId);
    } catch (_) {}
    await style.addSource(GeoJsonSource(id: sourceId, data: geoJson));
    await style.addLayer(CircleLayer(
      id: layerId,
      sourceId: sourceId,
      circleColor: color.toARGB32(),
      circleRadius: radius,
    ));
  }
  Future<Position?> getCoordinatesFromAddress(String address) async {
    return await _routeController.getCoordinatesFromAddress(address);
  }

  StationModel findNearestStation(Position position, List<StationModel> stations) {
    return _findNearestStation(position, stations);
  }

}