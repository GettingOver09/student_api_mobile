// lib/bloc/student_event.dart
abstract class StudentEvent {}

class FetchStudents extends StudentEvent {} // Trigger API call

class CreateStudent extends StudentEvent {
  final String username;
  final String email;
  final String password;

  CreateStudent(this.username, this.email, this.password);
}

class EditStudent extends StudentEvent {
  final int id;
  final String? username;
  final String? email;
  final String? password;

  EditStudent({required this.id, this.username, this.email, this.password});
}
