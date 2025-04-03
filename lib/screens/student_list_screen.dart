import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_mobile/bloc/student_bloc.dart';
import 'package:student_api_mobile/bloc/student_event.dart';
import 'package:student_api_mobile/bloc/student_state.dart';
import 'package:student_api_mobile/models/student.dart';
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
          } else if (state is StudentDeleting) {
            return Stack(
              children: [
                // Always show the current list (disabled)
                Opacity(
                  opacity: 0.5,
                  child: _buildStudentList(state.currentStudents),
                ),
                // Show loading indicator on top
                const Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (state is StudentDeleted) {
            // The FetchStudents will trigger automatically after deletion
            return BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                if (state is StudentLoaded) {
                  return _buildStudentList(state.students);
                }
                return Container();
              },
            );
          } else if (state is StudentLoaded) {
            return _buildStudentList(state.students);
          }
          return Container();
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

  Widget _buildStudentList(List<Student> students) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          title: Text(student.username),
          subtitle: Text(student.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStudentScreen(student: student),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, student.id),
              ),
            ],
          ),
        );
      },
    );
  }

  // Add this method to your StudentScreen class
  void _showDeleteDialog(BuildContext context, int studentId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this student?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<StudentBloc>().add(DeleteStudent(studentId));
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
