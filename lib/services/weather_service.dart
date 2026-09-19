import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '231ad28f4dfe407f9f6115435261907';

  Future<Map<String, dynamic>> getWeather({
    required String cityName,
  }) async {
    final Uri uri = Uri.https(
      'api.weatherapi.com',
      '/v1/forecast.json',
      {
        'key': apiKey,
        'q': cityName,
        'days': '1',
      },
    );

    final http.Response response = await http.get(uri);

    final Map<String, dynamic> decodeData =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return decodeData;
    }

    final String apiError = decodeData['error']?['message']?.toString() ?? '';

    if (apiError.contains('No matching location found')) {
      throw Exception('المكان غير موجود');
    }

    if (apiError.toLowerCase().contains('api key')) {
      throw Exception('يوجد خطأ في مفتاح API');
    }

    throw Exception('تعذر تحميل بيانات الطقس');
  }
}
