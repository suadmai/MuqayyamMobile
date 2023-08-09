class PrayerTime {
  final String name;
  final String time;

  PrayerTime({required this.name, required this.time});

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      name: json['name'],
      time: json['time'],
    );
  }
}

class PrayerZone {
  final String negeri;
  final String zon;
  final List<PrayerTime> waktuSolat;

  PrayerZone({required this.negeri, required this.zon, required this.waktuSolat});

  factory PrayerZone.fromJson(Map<String, dynamic> json) {
    List<dynamic> waktuSolatJson = json['waktu_solat'];
    List<PrayerTime> waktuSolat = waktuSolatJson.map((timeJson) => PrayerTime.fromJson(timeJson)).toList();

    return PrayerZone(
      negeri: json['negeri'],
      zon: json['zon'],
      waktuSolat: waktuSolat,
    );
  }
}
