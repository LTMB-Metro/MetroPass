import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:metropass/controller/map_contrller.dart';
import 'package:metropass/controller/station_controller.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/atlas_skeleton.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMap _mapboxMap;
  final MapContrller _mapContrller = MapContrller();
  final StationController _stationController = StationController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  late PointAnnotationManager _annotationManager;
  List<String> _startSuggestions = [];
  List<String> _endSuggestions = [];
  bool _isTypingStart = true;
  StationModel? findstartStation;
  StationModel? findendStation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: StreamBuilder<List<StationModel>>(
        stream: _stationController.getStations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: AtlasSkeleton());
          }
          final stations = snapshot.data!;
          return Stack(
            children: [
              MapWidget(
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
                  await _mapContrller.drawStationRoute(
                    stations: stations,
                    map: _mapboxMap, 
                    color: Colors.orange, 
                    sourceId: 'station_route_source', 
                    layerId: 'station_route_layer'
                    );
                  await _mapContrller.addStationMarkers(stations, _mapboxMap);
                  await _mapContrller.fitCameraToStationsAndIntermediatePoints(stations, _mapboxMap);
                  _annotationManager = await _mapboxMap.annotations.createPointAnnotationManager();
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                          ),
                          Expanded(child: _buiInputContainer(stations)),
                            ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: _buildRecommen(stations)
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildLocationInput(
    TextEditingController controller,
    String hint,
    bool isStart,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) async {
          final suggestions = await _mapContrller.getPlaceSuggestions(value);
          setState(() {
            _isTypingStart = isStart;
            if (isStart) {
              _startSuggestions = suggestions;
            } else {
              _endSuggestions = suggestions;
            }
          });
        },
        cursorColor: Color(MyColor.pr8),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(MyColor.pr9),
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Color(MyColor.black),
            fontSize: 13,
          ),
          suffix:controller.text.isNotEmpty ? GestureDetector(
            onTap: () {
              controller.clear();
              setState(() {
                if (isStart) {
                  _startSuggestions.clear();
                } else {
                  _endSuggestions.clear();
                }
              });
            },
            child: Icon(Icons.clear, size: 16),
          ) : null,
        ),
      ),
    );
  }

  Widget _buiInputContainer(List<StationModel> stations){
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Color(MyColor.pr2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_down.svg'
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLocationInput(_startController, 'Nhập địa điểm xuất phát', true),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Color(MyColor.pr8)
                      ),
                    ),
                    _buildLocationInput(_endController, 'Nhập địa điểm đến', false)
                  ],
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: ElevatedButton(
              onPressed: () {
                _mapContrller.handleSearchAndDrawRoute(
                  stations,
                  _mapboxMap,
                  _startController,
                  _endController,
                  _annotationManager
                );
                _findNearestStations(stations);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(MyColor.pr8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ), 
              child: Text(
                'Tìm đường',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(MyColor.white)
                ),
              )
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (_isTypingStart ? _startSuggestions : _endSuggestions).map((suggestion) {
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    suggestion,
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    setState(() {
                      if (_isTypingStart) {
                        _startController.text = suggestion;
                        _startSuggestions.clear();
                      } else {
                        _endController.text = suggestion;
                        _endSuggestions.clear();
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommen(List<StationModel> stations){
    if(findstartStation == null || findendStation == null){
      return Container();
    } else{
      
    }
    return 
    Container(
      margin: EdgeInsets.only(right: 20, left: 20),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Color(MyColor.pr2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Gợi \ný',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(MyColor.pr9)
                    ),
                  )
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Đi từ ga: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(MyColor.pr9)
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              findstartStation?.stationName ?? 'Chưa xác định',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(MyColor.pr9)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Color(MyColor.pr8)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Đi đến ga: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(MyColor.pr9)
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              findendStation?.stationName ?? 'Chưa xác định',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(MyColor.pr9)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _findNearestStations(List<StationModel> stations) async {
    final startText = _startController.text.trim();
    final endText = _endController.text.trim();

    if (startText.isEmpty || endText.isEmpty) return;

    final startCoord = await _mapContrller.getCoordinatesFromAddress(startText);
    final endCoord = await _mapContrller.getCoordinatesFromAddress(endText);

    if (startCoord == null || endCoord == null) {
      print('Không tìm thấy tọa độ từ địa chỉ');
      return;
    }

    final startStation = _mapContrller.findNearestStation(startCoord, stations);
    final endStation = _mapContrller.findNearestStation(endCoord, stations);

    setState(() {
      findstartStation = startStation;
      findendStation = endStation;
    });
  }

}