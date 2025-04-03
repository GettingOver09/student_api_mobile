// lib/services/student_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentApiService {
  static const String baseUrl = 'http://10.0.2.2:8001/api/';

  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse('${baseUrl}students'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((student) => Student.fromJson(student)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<Student> createStudent(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${baseUrl}students/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create student');
    }
  }

  Future<Student> updateStudent({
    required int id,
    String? username,
    String? email,
    String? password,
  }) async {
    final Map<String, dynamic> updateData = {};
    if (username != null) updateData['username'] = username;
    if (email != null) updateData['email'] = email;
    if (password != null) updateData['password'] = password;

    final response = await http.patch(
      Uri.parse('${baseUrl}students/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to update student (Status: ${response.statusCode})',
      );
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}students/$id/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete student (Status: ${response.statusCode})',
      );
    }
  }
}
