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
      throw Exception('Lỗi kết nối Mapbox: ${response.body}');
    }

    final data = jsonDecode(response.body);

    // ✅ Kiểm tra nếu không có tuyến nào
    final routes = data['routes'] as List;
    if (routes.isEmpty) {
      throw Exception('Mapbox không trả về tuyến đường nào. Có thể 2 điểm không nối được.');
    }

    final coords = routes[0]['geometry']['coordinates'] as List;
    return coords.map<Position>((c) => Position(c[0], c[1])).toList();
  }

  Future<Position?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(address)}.json?access_token=$accessToken',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      debugPrint('Lỗi khi lấy tọa độ: ${response.body}');
      return null;
    }

    final data = jsonDecode(response.body);
    if (data['features'].isEmpty) return null;

    final coords = data['features'][0]['geometry']['coordinates'];
    return Position(coords[0], coords[1]); // [lng, lat]
  }
  
  Future<void> drawCustomRouteOnMap({
    required MapboxMap map,
    required List<Position> route,
    required Color color,
    required String sourceId,
    required String layerId,
  }) async {
    final style = map.style;

    try {
      await style.removeStyleLayer(layerId);
    } catch (_) {}

    try {
      await style.removeStyleSource(sourceId);
    } catch (_) {}

    final geoJsonData = jsonEncode({
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": route.map((e) => [e.lng, e.lat]).toList(),
      },
    });

    await style.addSource(GeoJsonSource(id: sourceId, data: geoJsonData));

    await style.addLayer(LineLayer(
      id: layerId,
      sourceId: sourceId,
      lineColor: color.toARGB32(),
      lineWidth: 8.0,
    ));
  }
}
