class TimeData {
  final int pagi;
  final int siang;
  final int malam;

  const TimeData({this.pagi = 0, this.siang = 0, this.malam = 0});

  TimeData copyWith({int? pagi, int? siang, int? malam}) {
    return TimeData(
      pagi: pagi ?? this.pagi,
      siang: siang ?? this.siang,
      malam: malam ?? this.malam,
    );
  }
}


class ReportTimeData {
  /// key: 'yyyy-MM-dd'
  final Map<String, TimeData> dailyCounts;

  ReportTimeData({required this.dailyCounts});
}

