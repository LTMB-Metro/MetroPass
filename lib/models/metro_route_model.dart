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
          'Ba Son',
          'Công viên Văn Thánh',
          'Tân Cảng',
          'Thảo Điền',
          'An Phú',
          'Rạch Chiếc',
          'Phước Long',
          'Bình Thái',
          'Thủ Đức',
          'Khu Công nghệ cao',
          'Đại học Quốc gia',
          'Suối Tiên',
        ],
        depot: 'Long Bình, TP. Thủ Đức',
        status: 'Đã chính thức đưa vào vận hành từ ngày 22/12/2024',
        undergroundStations: ['Bến Thành', 'Nhà hát Thành phố', 'Ba Son'],
        elevatedStations: [
          'Công viên Văn Thánh',
          'Tân Cảng',
          'Thảo Điền',
          'An Phú',
          'Rạch Chiếc',
          'Phước Long',
          'Bình Thái',
          'Thủ Đức',
          'Khu Công nghệ cao',
          'Đại học Quốc gia',
          'Suối Tiên',
        ],
        routeDetails:
            'Bến Thành → Nhà hát Thành phố → Ba Son → Công viên Văn Thánh → Tân Cảng → Thảo Điền → An Phú → Rạch Chiếc → Phước Long → Bình Thái → Thủ Đức → Khu Công nghệ cao → Đại học Quốc gia → Suối Tiên',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 2',
        description: 'Bến Thành – Tham Lương',
        length: 11.3,
        undergroundLength: 9.6,
        elevatedLength: 1.7,
        stationCount: 11,
        undergroundStationCount: 10,
        elevatedStationCount: 1,
        stations: [
          'Bến Thành',
          'Chợ Lớn',
          'Bến xe Miền Tây',
          'Bình Phú',
          'Bình Hưng',
          'Tham Lương',
        ],
        depot: 'Tham Lương, Quận 12',
        status: 'Đang triển khai, dự kiến hoàn thành vào năm 2030',
        undergroundStations: ['Bến Thành', 'Chợ Lớn', 'Bến xe Miền Tây', 'Bình Phú', 'Bình Hưng'],
        elevatedStations: ['Tham Lương'],
        routeDetails:
            'Bến Thành → Chợ Lớn → Bến xe Miền Tây → Bình Phú → Bình Hưng → Tham Lương (Quận 12)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 3A',
        description: 'Bến Thành – Tân Kiên',
        length: 16.9,
        undergroundLength: 0.0,
        elevatedLength: 16.9,
        stationCount: 16,
        undergroundStationCount: 0,
        elevatedStationCount: 16,
        stations: ['Bến Thành', 'Chợ Lớn', 'Bến xe Miền Tây', 'Tân Kiên'],
        depot: 'Tân Kiên, huyện Bình Chánh',
        status: 'Đang trong giai đoạn nghiên cứu khả thi',
        undergroundStations: [],
        elevatedStations: ['Bến Thành', 'Chợ Lớn', 'Bến xe Miền Tây', 'Tân Kiên'],
        routeDetails:
            'Bến Thành → Chợ Lớn → Bến xe Miền Tây → Tân Kiên (huyện Bình Chánh)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 3B',
        description: 'Ngã tư Cộng Hòa – Hiệp Bình Phước',
        length: 6.2,
        undergroundLength: 0.0,
        elevatedLength: 6.2,
        stationCount: 7,
        undergroundStationCount: 0,
        elevatedStationCount: 7,
        stations: [
          'Ngã tư Cộng Hòa',
          'Công viên Hoàng Văn Thụ',
          'Sân bay Tân Sơn Nhất',
          'Bình Triệu',
          'Hiệp Bình Phước',
        ],
        depot: 'Hiệp Bình Phước, TP. Thủ Đức',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: [],
        elevatedStations: [
          'Ngã tư Cộng Hòa',
          'Công viên Hoàng Văn Thụ',
          'Sân bay Tân Sơn Nhất',
          'Bình Triệu',
          'Hiệp Bình Phước',
        ],
        routeDetails:
            'Ngã tư Cộng Hòa → Công viên Hoàng Văn Thụ → Sân bay Tân Sơn Nhất → Bình Triệu → Hiệp Bình Phước (TP. Thủ Đức)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 4',
        description: 'Thạnh Xuân – Khu đô thị Hiệp Phước',
        length: 16.7,
        undergroundLength: 0.0,
        elevatedLength: 16.7,
        stationCount: 15,
        undergroundStationCount: 0,
        elevatedStationCount: 15,
        stations: ['Thạnh Xuân', 'Khu đô thị Hiệp Phước'],
        depot: 'Khu đô thị Hiệp Phước, huyện Nhà Bè',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: [],
        elevatedStations: ['Thạnh Xuân', 'Khu đô thị Hiệp Phước'],
        routeDetails:
            'Thạnh Xuân (Quận 12) → Khu đô thị Hiệp Phước (huyện Nhà Bè)',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 4B',
        description: 'Công viên Gia Định – Ga Láng Cha Cả',
        length: 3.9,
        undergroundLength: 3.9,
        elevatedLength: 0.0,
        stationCount: 4,
        undergroundStationCount: 4,
        elevatedStationCount: 0,
        stations: ['Công viên Gia Định', 'Ga Láng Cha Cả'],
        depot: 'Ga Láng Cha Cả',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: ['Công viên Gia Định', 'Ga Láng Cha Cả'],
        elevatedStations: [],
        routeDetails: 'Công viên Gia Định → Ga Láng Cha Cả',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 5',
        description: 'Bến xe Cần Giuộc – Cầu Sài Gòn',
        length: 24.2,
        undergroundLength: 3.0,
        elevatedLength: 21.2,
        stationCount: 20,
        undergroundStationCount: 3,
        elevatedStationCount: 17,
        stations: [
          'Bến xe Cần Giuộc',
          'Nguyễn Văn Linh',
          'Cầu Sài Gòn',
        ],
        depot: 'Cần Giuộc, Long An',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: ['Cầu Sài Gòn'],
        elevatedStations: ['Bến xe Cần Giuộc', 'Nguyễn Văn Linh'],
        routeDetails:
            'Bến xe Cần Giuộc (Long An) → Nguyễn Văn Linh → Cầu Sài Gòn',
      ),
      MetroRoute(
        name: 'Tuyến Metro số 6',
        description: 'Chợ Lớn – Suối Tiên',
        length: 13.1,
        undergroundLength: 0.0,
        elevatedLength: 13.1,
        stationCount: 12,
        undergroundStationCount: 0,
        elevatedStationCount: 12,
        stations: ['Chợ Lớn', 'Suối Tiên'],
        depot: 'Suối Tiên',
        status: 'Đang trong giai đoạn quy hoạch',
        undergroundStations: [],
        elevatedStations: ['Chợ Lớn', 'Suối Tiên'],
        routeDetails: 'Chợ Lớn → Suối Tiên',
      ),
    ];
  }
}
