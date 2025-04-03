// lib/bloc/student_state.dart
import 'package:student_api_mobile/models/student.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {} // Initial state

class StudentLoading extends StudentState {} // Loading state

// Success state
class StudentLoaded extends StudentState {
  final List<Student> students;
  StudentLoaded(this.students);
}

class StudentCreating extends StudentState {} // When creating

class StudentCreated extends StudentState {} // On success

class StudentEditing extends StudentState {}

// Student Edited
class StudentEdited extends StudentState {
  final Student student;
  StudentEdited(this.student);
}

class StudentDeleting extends StudentState {
  final List<Student> currentStudents;
  StudentDeleting(this.currentStudents);
}

class StudentDeleted extends StudentState {
  final int deletedId;
  StudentDeleted(this.deletedId);
}

// Error state
class StudentError extends StudentState {
  final String error;
  StudentError(this.error);
}
