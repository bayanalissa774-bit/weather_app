import 'package:flutter/material.dart';
import 'weather_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SearchPage> {
  final TextEditingController cityController = TextEditingController();

  Color searchColor = Colors.orange;

  Color getWeatherColor(String condition) {
    final String weatherCondition = condition.toLowerCase();

    if (weatherCondition.contains('sunny') ||
        weatherCondition.contains('clear')) {
      return Colors.amber;
    }

    if (weatherCondition.contains('rain') ||
        weatherCondition.contains('drizzle')) {
      return Colors.blueGrey;
    }

    if (weatherCondition.contains('cloud') ||
        weatherCondition.contains('overcast')) {
      return Colors.grey;
    }

    if (weatherCondition.contains('snow') ||
        weatherCondition.contains('sleet')) {
      return Colors.lightBlue;
    }

    if (weatherCondition.contains('thunder')) {
      return Colors.deepPurple;
    }

    if (weatherCondition.contains('mist') || weatherCondition.contains('fog')) {
      return Colors.blueGrey;
    }

    return Colors.orange;
  }

  Future<void> openWeatherDetails() async {
    final String cityName = cityController.text.trim();

    if (cityName.isEmpty) {
      return;
    }

    final String? condition = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherDetailsPage(
          cityName: cityName,
        ),
      ),
    );

    if (!mounted) return;

    if (condition != null) {
      setState(() {
        searchColor = getWeatherColor(condition);
      });
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text('Search a Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: cityController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            openWeatherDetails();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: searchColor.withOpacity(0.15),
            hintText: 'Enter any place',
            suffixIcon: IconButton(
              onPressed: openWeatherDetails,
              icon: Icon(
                Icons.search,
                color: searchColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: searchColor,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: searchColor,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
