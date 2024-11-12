import 'dart:async';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/data_model.dart';

void main() {
  runApp(DataDisplayApp());
}

class DataDisplayApp extends StatefulWidget {
  @override
  _DataDisplayAppState createState() => _DataDisplayAppState();
}

class _DataDisplayAppState extends State<DataDisplayApp> {
  bool _isDarkMode = false; // Variabel untuk status tema

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Display App',
      theme: _isDarkMode
          ? ThemeData.dark()
          : ThemeData.light(), // Pilih tema berdasarkan _isDarkMode
      home: DataDisplayPage(
        onThemeChanged: (bool isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
        isDarkMode:
            _isDarkMode, // Kirimkan status tema ke halaman DataDisplayPage
      ),
    );
  }
}

class DataDisplayPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode; // Terima status tema

  DataDisplayPage({required this.onThemeChanged, required this.isDarkMode});

  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  final ApiService apiService = ApiService();
  DataModel? data;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void fetchData() async {
    try {
      DataModel newData = await apiService.fetchData();
      setState(() {
        data = newData;
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bayu Monitoring Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle antara tema gelap dan terang
              widget.onThemeChanged(!widget.isDarkMode);
            },
          ),
        ],
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : buildDataDisplay(data!),
    );
  }

  Widget buildDataDisplay(DataModel data) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.blue.shade50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Horizontal container for suhu max, min, rata-rata
              Text(
                'Temperature Statistic',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10), // Memberi jarak antara judul dan container
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildDataColumn(
                        'Suhu Max', data.suhumax.toString(), Icons.thermostat),
                    buildDataColumn(
                        'Suhu Min', data.suhummin.toString(), Icons.ac_unit),
                    buildDataColumn('Suhu Rata-Rata', data.suhurata.toString(),
                        Icons.trending_up),
                  ],
                ),
              ),

              SizedBox(height: 20),
              // Nilai Suhu Max Humid Max Section with Title
              Text(
                'Nilai Suhu Max Humid Max',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: data.nilaiSuhuMaxHumidMax
                      .map((item) => buildSuhuMaxHumidCard(item))
                      .toList(),
                ),
              ),
              // Month Year Max Section with Title
              Text(
                'Month Year Max',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: data.monthYearMax
                      .map((item) => buildCard('Month Year', item.monthYear))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDataColumn(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 40),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }

  Widget buildCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildSuhuMaxHumidCard(SuhuMaxHumidMax item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('IDX: ${item.idx}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.thermostat_outlined, color: Colors.orange),
                SizedBox(width: 5),
                Text('Suhu: ${item.suhu}°C'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.water_damage, color: Colors.blue),
                SizedBox(width: 5),
                Text('Humidity: ${item.humid}%'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.yellow),
                SizedBox(width: 5),
                Text('Kecerahan: ${item.kecerahan}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 5),
                Text('Timestamp: ${item.timestamp}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
