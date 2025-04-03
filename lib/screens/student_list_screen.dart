import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_mobile/bloc/student_bloc.dart';
import 'package:student_api_mobile/bloc/student_event.dart';
import 'package:student_api_mobile/bloc/student_state.dart';
import 'package:student_api_mobile/screens/add_student_screen.dart';
import 'package:student_api_mobile/screens/edit_student_screen.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStudentScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentInitial) {
            return const Center(
              child: Text('Press the button to load students'),
            );
          } else if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is StudentLoaded) {
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return ListTile(
                  title: Text(student.username),
                  subtitle: Text(student.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditStudentScreen(student: student),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return Container(); // Fallback
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<StudentBloc>().add(FetchStudents());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
