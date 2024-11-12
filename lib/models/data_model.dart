class DataModel {
  final int suhumax;
  final int suhummin;
  final double suhurata;
  final List<SuhuMaxHumidMax> nilaiSuhuMaxHumidMax;
  final List<MonthYearMax> monthYearMax;

  DataModel({
    required this.suhumax,
    required this.suhummin,
    required this.suhurata,
    required this.nilaiSuhuMaxHumidMax,
    required this.monthYearMax,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      suhumax: json['suhumax'],
      suhummin: json['suhummin'],
      suhurata: json['suhurata'],
      nilaiSuhuMaxHumidMax: (json['nilai_suhu_max_humid_max'] as List)
          .map((item) => SuhuMaxHumidMax.fromJson(item))
          .toList(),
      monthYearMax: (json['month_year_max'] as List)
          .map((item) => MonthYearMax.fromJson(item))
          .toList(),
    );
  }
}

class SuhuMaxHumidMax {
  final int idx;
  final int suhu;
  final int humid;
  final int kecerahan;
  final String timestamp;

  SuhuMaxHumidMax({
    required this.idx,
    required this.suhu,
    required this.humid,
    required this.kecerahan,
    required this.timestamp,
  });

  factory SuhuMaxHumidMax.fromJson(Map<String, dynamic> json) {
    return SuhuMaxHumidMax(
      idx: json['idx'],
      suhu: json['suhu'],
      humid: json['humid'],
      kecerahan: json['kecerahan'],
      timestamp: json['timestamp'],
    );
  }
}

class MonthYearMax {
  final String monthYear;

  MonthYearMax({required this.monthYear});

  factory MonthYearMax.fromJson(Map<String, dynamic> json) {
    return MonthYearMax(
      monthYear: json['month_year'],
    );
  }
}
