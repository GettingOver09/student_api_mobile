// lib/bloc/student_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_mobile/bloc/student_event.dart';
import 'package:student_api_mobile/bloc/student_state.dart';
import 'package:student_api_mobile/services/student_api_service.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentApiService studentApiService;

  StudentBloc(this.studentApiService) : super(StudentInitial()) {
    on<FetchStudents>(_onFetchStudents);
    on<CreateStudent>(_onCreateStudent);
    on<EditStudent>(_onEditStudent);
    on<DeleteStudent>(_onDeleteStudent);
  }

  Future<void> _onFetchStudents(
    FetchStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final students = await studentApiService.getStudents();
      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onCreateStudent(
    CreateStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentCreating());

    try {
      await studentApiService.createStudent(
        event.username,
        event.email,
        event.password,
      );
      emit(StudentCreated());
      add(FetchStudents());
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onEditStudent(
    EditStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentEditing());
    try {
      final updatedStudent = await studentApiService.updateStudent(
        id: event.id,
        username: event.username,
        email: event.email,
        password: event.password,
      );
      emit(StudentEdited(updatedStudent));
      add(FetchStudents());
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onDeleteStudent(
    DeleteStudent event,
    Emitter<StudentState> emit,
  ) async {
    if (state is StudentLoaded) {
      final currentStudents = (state as StudentLoaded).students;
      emit(StudentDeleting(currentStudents));

      try {
        await studentApiService.deleteStudent(event.id);
        emit(StudentDeleted(event.id));
        add(FetchStudents());
      } catch (e) {
        emit(StudentError(e.toString()));
        emit(StudentLoaded(currentStudents));
      }
    }
  }
}
