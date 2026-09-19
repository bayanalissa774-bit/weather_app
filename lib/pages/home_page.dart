import 'package:flutter/material.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? cityName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text(
            'Weather',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final String? result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );

                if (result != null && result.trim().isNotEmpty) {
                  setState(() {
                    cityName = result.trim();
                  });
                }
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: cityName == null
            ? const Center(
                child: Text(
                  "there is no weather 😔\nstart searching now 🔍",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cityName!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "updated at : 23:46",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ));
  }
}
