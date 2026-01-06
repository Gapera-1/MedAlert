import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your computer's IP address for physical devices
  // For Android emulator: 10.0.2.2
  // For iOS simulator: localhost
  // For physical device: Your computer's local IP (e.g., 192.168.1.100)
  static const String _host = '10.0.2.2'; // Change this if needed
  static const String _port = '8000';
  
  static String get apiBaseUrl {
    // For iOS simulator, use localhost
    if (Platform.isIOS) {
      return 'http://localhost:$_port/api';
    }
    // For Android emulator, use 10.0.2.2
    // For physical devices, update _host to your computer's IP
    return 'http://$_host:$_port/api';
  }

  // Helper method to handle API responses
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return json.decode(response.body);
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'An error occurred');
      } catch (e) {
        throw Exception('HTTP error! status: ${response.statusCode}');
      }
    }
  }

  // Authentication APIs
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String password,
    String? email,
  }) async {
    final body = <String, dynamic>{
      'username': username,
      'password': password,
    };
    
    if (email != null && email.isNotEmpty) {
      body['email'] = email;
    }

    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/signup/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> login({
    String? username,
    String? password,
    String? email,
  }) async {
    final body = <String, dynamic>{};
    
    if (password != null) {
      body['password'] = password;
    }
    if (username != null && username.isNotEmpty) {
      body['username'] = username;
    }
    if (email != null && email.isNotEmpty) {
      body['email'] = email;
    }

    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _handleResponse(response);
  }

  // Medicine APIs
  static Future<List<dynamic>> fetchMedicines() async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/medicines/'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = _handleResponse(response);
    return data is List ? data : [];
  }

  static Future<Map<String, dynamic>> createMedicine({
    required String name,
    required List<String> times,
    required String posology,
    required int duration,
  }) async {
    final body = {
      'name': name,
      'times': times,
      'posology': posology,
      'duration': duration,
    };

    final response = await http.post(
      Uri.parse('$apiBaseUrl/medicines/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateMedicine(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await http.put(
      Uri.parse('$apiBaseUrl/medicines/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    return _handleResponse(response);
  }

  static Future<void> deleteMedicine(int id) async {
    final response = await http.delete(
      Uri.parse('$apiBaseUrl/medicines/$id/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete medicine');
    }
  }

  static Future<Map<String, dynamic>> markMedicineTaken(
    int id,
    String time,
  ) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/medicines/$id/mark_taken/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'time': time}),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> markMedicineCompleted(int id) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/medicines/$id/mark_completed/'),
      headers: {'Content-Type': 'application/json'},
    );

    return _handleResponse(response);
  }
}

