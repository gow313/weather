import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(api);
  Weather? _weather;
  DateTime? now;
  TextEditingController loc = TextEditingController();
  String name = "ooty";
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    Weather weather = await _wf.currentWeatherByCityName('Madurai');
    setState(() {
      _weather = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      now = _weather!.date;
      return Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/weather.png'), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.areaName ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 30)),
            Text(DateFormat.yMMMMd().format(now!),
                style: const TextStyle(color: Colors.white, fontSize: 15)),
            Image(
                image: NetworkImage(
                    "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png")),
            Text(
              "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(_weather?.weatherMain ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 12),
              width: MediaQuery.sizeOf(context).width / 2,
              height: 50,
              decoration: BoxDecoration(color: Colors.white),
              child: TextFormField(
                decoration: InputDecoration(border: InputBorder.none),
                controller: loc,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                String cityName = loc.text.trim();
                setState(() {
                  name = cityName;
                  _weather = null;
                });
                _fetchWeather();
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width / 2,
                height: 50,
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                    child: Text(
                  "Find",
                )),
              ),
            ),
          ],
        ),
      );
    }
  }
}
