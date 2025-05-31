import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


// Controller lấy đường đi thực tế
class MapboxRouteController {
  final String accessToken;

  MapboxRouteController({required this.accessToken});

  Future<List<Position>> getRouteCoordinates({
    required Position origin,
    required Position destination,
  }) async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.lng},${origin.lat};${destination.lng},${destination.lat}?geometries=geojson&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch route: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final coords = data['routes'][0]['geometry']['coordinates'] as List;
    return coords.map<Position>((c) => Position(c[0], c[1])).toList();
  }

  Future<void> drawRouteOnMap({
    required MapboxMap map,
    required List<Position> route,
  }) async {
    final geoJsonData = jsonEncode({
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": route.map((e) => [e.lng, e.lat]).toList(),
      },
      "properties": {}
    });

    await map.style.addSource(GeoJsonSource(
      id: 'route_source',
      data: geoJsonData,
    ));

    await map.style.addLayer(LineLayer(
      id: 'route_layer',
      sourceId: 'route_source',
      lineColor: Colors.red.value,
      lineWidth: 5.0,
    ));
  }
}
