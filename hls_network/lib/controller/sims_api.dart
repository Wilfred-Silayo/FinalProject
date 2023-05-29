import 'package:http/http.dart' as http;

class SimsApi {
  final String app_key = 'base64:esd6rxNI6hJc9/lCZpq0jEf266iLPx5KLp9p/JLKk2M=';
  final String _baseUrl = 'http://192.168.43.97/api';
  final String baseUrl;
  // final String _baseUrl = "http://127.0.0.1:8000/api";

  const SimsApi({required this.baseUrl});
  Future<http.Response> generateToken(String registrationNumber) async {
    final url = Uri.parse("$_baseUrl/generate/token");
    final response = await http.post(
      url,
      body: {
        "user": registrationNumber,
        "app_key": app_key,
      },
    );
    return response;
  }

  Future<http.Response> verifyToken(
      String registrationNumber, String token) async {
    final url = Uri.parse("$_baseUrl/verify/token");
    final response = await http.post(
      url,
      body: {
        "user": registrationNumber,
        "app_key": app_key,
        "token": token,
      },
    );
    return response;
  }
}
