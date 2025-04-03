// lib/models/student.dart
class Student {
  final int id;
  final String username;
  final String email;

  Student({required this.id, required this.username, required this.email});

  // The fromJson that helps convert a JSON object (retrieved from an API or database) into a Student object in Dart.
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  // Convert a Student object to JSON Map
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email};
  }
}
