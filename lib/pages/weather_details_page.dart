import 'package:flutter/material.dart';
import 'search_page.dart';
import '../services/weather_service.dart';

class WeatherDetailsPage extends StatefulWidget {
  final String cityName;
  const WeatherDetailsPage({super.key, required this.cityName});

  @override
  State<WeatherDetailsPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WeatherDetailsPage> {
  final WeatherService weatherService = WeatherService();
  late Future<Map<String, dynamic>> weatherData;
  String? currentCondition;
  @override
  void initState() {
    super.initState();
    weatherData = weatherService.getWeather(
      cityName: widget.cityName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1E88E5),
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black38,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, currentCondition);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Weather App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff2196F3),
              Color(0xffBBDEFB),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              final String errorMessage =
                  snapshot.error.toString().replaceFirst('Exception: ', '');

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('العودة إلى البحث'),
                    ),
                  ],
                ),
              );
            }
            final Map<String, dynamic> data = snapshot.data!;

            final String cityName = data["location"]["name"];
            final String regionName =
                data["location"]["region"]?.toString() ?? '';

            final String countryName =
                data["location"]["country"]?.toString() ?? '';
            final num temperature = data["current"]["temp_c"];

            final num maxTemperature =
                data["forecast"]["forecastday"][0]["day"]["maxtemp_c"];
            final num minTemperature =
                data["forecast"]["forecastday"][0]["day"]["mintemp_c"];
            final String condition = data["current"]["condition"]["text"];
            currentCondition = condition;

            final String iconPath =
                data["current"]["condition"]["icon"]?.toString() ?? '';

            final String iconUrl =
                iconPath.startsWith('//') ? "https:$iconPath" : iconPath;
            final String lastUpdated =
                data['current']['last_updated']?.toString() ?? '';

            final String updatedTime = lastUpdated.contains(' ')
                ? lastUpdated.split(' ').last
                : '--:--';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$regionName, $countryName',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'updated at : $updatedTime',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconUrl.isEmpty
                          ? const Icon(
                              Icons.cloud,
                              size: 75,
                              color: Colors.blueGrey,
                            )
                          : Image.network(
                              iconUrl,
                              width: 75,
                              height: 75,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.cloud,
                                  size: 75,
                                  color: Colors.blueGrey,
                                );
                              },
                            ),
                      Text(
                        '$temperature°',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('max temp: $maxTemperature°'),
                          Text('min temp: $minTemperature°'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Text(
                    condition,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
