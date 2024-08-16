import 'package:flores_hikers_watch_app/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WeatherScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherScreen(
      {super.key, required this.latitude, required this.longitude});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  final WeatherFactory wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? weather;

  WeatherScreenState();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    wf
        .currentWeatherByLocation(widget.latitude, widget.longitude)
        .then((value) {
      setState(() {
        weather = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F5),
        title: const Text('Weather'),
      ),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    if (weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            locationHeather(),
            Gap(MediaQuery.sizeOf(context).height * 0.08),
            dateTimeInfo(),
            Gap(MediaQuery.sizeOf(context).height * 0.05),
            weatherIcon(),
            Gap(MediaQuery.sizeOf(context).height * 0.02),
            currentTemp(),
            Gap(MediaQuery.sizeOf(context).height * 0.02),
            extraInfo(),
            Gap(MediaQuery.sizeOf(context).height * 0.02),
          ],
        ),
      );
    }
  }

  Widget locationHeather() {
    return Text(
      weather?.areaName ?? '',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget dateTimeInfo() {
  DateTime now = weather!.date!;

  // Get the timezone for the Philippines
  const String timeZoneName = 'Asia/Manila';
  final timeZone = tz.getLocation(timeZoneName);

  // Convert UTC time to local time in the Philippines timezone
  final localTime = tz.TZDateTime.from(now.toUtc(), timeZone);

  String formattedTime = DateFormat("h:mm a").format(localTime);
  String formattedDate = DateFormat("EEEE   MMMM d, yyyy").format(localTime);

  return Column(
    children: [
      Text(
        formattedTime,
        style: const TextStyle(
          fontSize: 35,
        ),
      ),
      const Gap(10),
      Text(
        formattedDate,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
  }

  Widget weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/weather_icon.png",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget currentTemp() {
    return Text(
      "${weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  
  Widget extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: const Color(0xff273ea5),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity: ${weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
