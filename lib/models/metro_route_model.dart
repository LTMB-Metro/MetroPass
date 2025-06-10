class MetroRoute {
  final String name;
  final String description;
  final double length;
  final double undergroundLength;
  final double elevatedLength;
  final int stationCount;
  final int undergroundStationCount;
  final int elevatedStationCount;
  final List<String> stations;
  final String depot;
  final String status;
  final List<String> undergroundStations;
  final List<String> elevatedStations;
  final String routeDetails;

  MetroRoute({
    required this.name,
    required this.description,
    required this.length,
    required this.undergroundLength,
    required this.elevatedLength,
    required this.stationCount,
    required this.undergroundStationCount,
    required this.elevatedStationCount,
    required this.stations,
    required this.depot,
    required this.status,
    required this.undergroundStations,
    required this.elevatedStations,
    required this.routeDetails,
  });

  static List<MetroRoute> getRoutes() {
    return [
      MetroRoute(
        name: 'Tuyến Metro số 1',
        description: 'Bến Thành – Suối Tiên',
        length: 19.7,
        undergroundLength: 2.6,
        elevatedLength: 17.1,
        stationCount: 14,
        undergroundStationCount: 3,
        elevatedStationCount: 11,
        stations: [
          'Bến Thành',
          'Nhà hát Thành phố',
          'Lê Lợi',
          'Nguyễn Siêu',
          'Ngô Văn Năm',
          'Tôn Đức Thắng',
          'Ba Son',
          'Nguyễn Hữu Cảnh',
          'Văn Thánh',
          'Điện Biên Phủ',
          'Cầu Sài Gòn',
          'Xa lộ Hà Nội',
          'Depot Long Bình',
        ],
        depot: 'Long Bình, TP. Thủ Đức',
        status:
            'Đã hoàn thành và dự kiến đưa vào vận hành chính thức vào Quý 4/2024',
        undergroundStations: ['Bến Thành', 'Nhà hát Thành phố', 'Ba Son'],
        elevatedStations: [
          'Lê Lợi',
          'Nguyễn Siêu',
          'Ngô Văn Năm',
          'Tôn Đức Thắng',
          'Nguyễn Hữu Cảnh',
          'Văn Thánh',
          'Điện Biên Phủ',
          'Cầu Sài Gòn',
          'Xa lộ Hà Nội',
          'Depot Long Bình',
        ],
        routeDetails:
            'Bến Thành → Nhà hát Thành phố → Lê Lợi → Nguyễn Siêu → Ngô Văn Năm → Tôn Đức Thắng → Ba Son → Nguyễn Hữu Cảnh → Văn Thánh → Điện Biên Phủ → cầu Sài Gòn → xa lộ Hà Nội → Depot Long Bình (TP. Thủ Đức)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 2',
        description: 'Bến Thành – Tham Lương',
        length: 48.0,
        undergroundLength: 0.0,
        elevatedLength: 0.0,
        stationCount: 42,
        undergroundStationCount: 16,
        elevatedStationCount: 10,
        stations: [
          'Bến Thành',
          'Phạm Hồng Thái',
          'Cách Mạng Tháng 8',
          'Trường Chinh',
          'Tham Lương',
        ],
        depot: 'Tham Lương, Quận 12',
        status: 'Đang triển khai, dự kiến hoàn thành vào năm 2026',
        undergroundStations: [],
        elevatedStations: [],
        routeDetails:
            'Bến Thành → Phạm Hồng Thái → Cách Mạng Tháng 8 → Trường Chinh → Tham Lương (Quận 12)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 3A',
        description: 'Bến Thành – Tân Kiên',
        length: 19.8,
        undergroundLength: 0.0,
        elevatedLength: 0.0,
        stationCount: 18,
        undergroundStationCount: 0,
        elevatedStationCount: 0,
        stations: ['Bến Thành', 'Bến xe Miền Tây', 'Tân Kiên'],
        depot: 'Tân Kiên, huyện Bình Chánh',
        status:
            'Đang trong giai đoạn nghiên cứu tiền khả thi và kêu gọi vốn đầu tư',
        undergroundStations: [],
        elevatedStations: [],
        routeDetails:
            'Bến Thành → Bến xe Miền Tây → Tân Kiên (huyện Bình Chánh)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 3B',
        description: 'Ngã 6 Cộng Hòa – Hiệp Bình Phước',
        length: 12.1,
        undergroundLength: 0.0,
        elevatedLength: 0.0,
        stationCount: 10,
        undergroundStationCount: 0,
        elevatedStationCount: 0,
        stations: [
          'Ngã 6 Cộng Hòa',
          'Nguyễn Thị Minh Khai',
          'Xô Viết Nghệ Tĩnh',
          'Quốc lộ 13',
          'Hiệp Bình Phước',
        ],
        depot: 'Hiệp Bình Phước, TP. Thủ Đức',
        status: 'Đang được triển khai',
        undergroundStations: [],
        elevatedStations: [],
        routeDetails:
            'Ngã 6 Cộng Hòa → Nguyễn Thị Minh Khai → Xô Viết Nghệ Tĩnh → Quốc lộ 13 → Hiệp Bình Phước (TP. Thủ Đức)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 4',
        description: 'Thạnh Xuân – Khu đô thị Hiệp Phước',
        length: 35.8,
        undergroundLength: 0.0,
        elevatedLength: 0.0,
        stationCount: 32,
        undergroundStationCount: 0,
        elevatedStationCount: 0,
        stations: ['Thạnh Xuân', 'Khu đô thị Hiệp Phước'],
        depot: 'Khu đô thị Hiệp Phước, huyện Nhà Bè',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: [],
        elevatedStations: [],
        routeDetails:
            'Thạnh Xuân (Quận 12) → Khu đô thị Hiệp Phước (huyện Nhà Bè)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 4B',
        description: 'Công viên Gia Định – Công viên Hoàng Văn Thụ',
        length: 3.2,
        undergroundLength: 0.0,
        elevatedLength: 0.0,
        stationCount: 3,
        undergroundStationCount: 0,
        elevatedStationCount: 0,
        stations: ['Công viên Gia Định', 'Công viên Hoàng Văn Thụ'],
        depot: 'Công viên Hoàng Văn Thụ',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: [],
        elevatedStations: [],
        routeDetails: 'Công viên Gia Định → Công viên Hoàng Văn Thụ',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 5',
        description: 'Ngã tư Bảy Hiền – Cầu Sài Gòn',
        length: 23.4,
        undergroundLength: 0.0,
        elevatedLength: 0.0,
        stationCount: 22,
        undergroundStationCount: 16,
        elevatedStationCount: 6,
        stations: [
          'Bến xe Cần Giuộc mới',
          'Quốc lộ 50',
          'Tùng Thiện Vương',
          'Phù Đổng Thiên Vương',
          'Lý Thường Kiệt',
          'Hoàng Văn Thụ',
          'Phan Đăng Lưu',
          'Bạch Đằng',
          'Điện Biên Phủ',
          'Cầu Sài Gòn',
        ],
        depot: 'Cầu Sài Gòn',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: [],
        elevatedStations: [],
        routeDetails:
            'Bến xe Cần Giuộc mới → Quốc lộ 50 → Tùng Thiện Vương → Phù Đổng Thiên Vương → Lý Thường Kiệt → Hoàng Văn Thụ → Phan Đăng Lưu → Bạch Đằng → Điện Biên Phủ → cầu Sài Gòn',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 6',
        description: 'Bà Quẹo – Vòng xoay Phú Lâm',
        length: 6.8,
        undergroundLength: 0.0,
        elevatedLength: 0.0,
        stationCount: 7,
        undergroundStationCount: 0,
        elevatedStationCount: 0,
        stations: ['Bà Quẹo', 'Vòng xoay Phú Lâm'],
        depot: 'Vòng xoay Phú Lâm',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: [],
        elevatedStations: [],
        routeDetails: 'Bà Quẹo → Vòng xoay Phú Lâm',
      ),
    ];
  }
}
