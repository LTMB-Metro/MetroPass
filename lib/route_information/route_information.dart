import 'package:flutter/material.dart';
import '../models/metro_route_model.dart';
import '../themes/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RouteInformationPage extends StatelessWidget {
  const RouteInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = MetroRoute.getRoutes();
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr2);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.routeInformation, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(MyColor.pr6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          route.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          route.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(l10n.routeLength, '${route.length} ${l10n.km}'),
                  if (route.undergroundLength > 0)
                    _buildInfoRow(
                      'Chiều dài ngầm',
                      '${route.undergroundLength} ${l10n.km}',
                    ),
                  if (route.elevatedLength > 0)
                    _buildInfoRow(
                      'Chiều dài trên cao',
                      '${route.elevatedLength} ${l10n.km}',
                    ),
                  _buildInfoRow(
                    l10n.stationCount,
                    '${route.stationCount} ${l10n.stations}',
                  ),
                  if (route.undergroundStationCount > 0)
                    _buildInfoRow(
                      'Số ga ngầm',
                      '${route.undergroundStationCount} ${l10n.stations}',
                    ),
                  if (route.elevatedStationCount > 0)
                    _buildInfoRow(
                      'Số ga trên cao',
                      '${route.elevatedStationCount} ${l10n.stations}',
                    ),
                  _buildInfoRow(l10n.depot, route.depot),
                  _buildInfoRow(l10n.status, route.status),
                  const SizedBox(height: 16),
                  Text(
                    l10n.routeDetails,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(MyColor.pr3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(MyColor.pr3), width: 1),
                    ),
                    child: Text(
                      route.routeDetails,
                      style: TextStyle(fontSize: 14, color: Color(MyColor.pr9)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.stationList,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        route.stations.map((station) {
                          final isUnderground = route.undergroundStations
                              .contains(station);
                          final isElevated = route.elevatedStations.contains(
                            station,
                          );

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isUnderground
                                      ? Color(MyColor.pr8)
                                      : isElevated
                                      ? Color(MyColor.pr5)
                                      : Color(MyColor.pr3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              station,
                              style: TextStyle(
                                color:
                                    isUnderground || isElevated
                                        ? Colors.white
                                        : Color(MyColor.pr9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLegendItem(
                        l10n.undergroundStation,
                        Color(MyColor.pr8),
                      ),
                      const SizedBox(width: 16),
                      _buildLegendItem(
                        l10n.elevatedStation,
                        Color(MyColor.pr5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A4BB6),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
