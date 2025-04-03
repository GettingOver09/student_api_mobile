import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_mobile/bloc/student_bloc.dart';
import 'package:student_api_mobile/bloc/student_event.dart';
import 'package:student_api_mobile/screens/student_list_screen.dart';
import 'package:student_api_mobile/services/student_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => StudentBloc(StudentApiService())..add(FetchStudents()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const StudentScreen(),
      ),
    );
  }
}
