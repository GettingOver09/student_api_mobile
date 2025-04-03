import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_mobile/bloc/student_bloc.dart';
import 'package:student_api_mobile/bloc/student_event.dart';
import 'package:student_api_mobile/bloc/student_state.dart';
import 'package:student_api_mobile/models/student.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen({super.key, required this.student});
  final Student student;

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.student.username);
    _emailController = TextEditingController(text: widget.student.email);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              BlocConsumer<StudentBloc, StudentState>(
                listener: (context, state) {
                  if (state is StudentEdited) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student updated successfully!'),
                      ),
                    );
                  }
                  if (state is StudentError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        state is StudentEditing
                            ? null
                            : () {
                              context.read<StudentBloc>().add(
                                EditStudent(
                                  id: widget.student.id,
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  password:
                                      _passwordController.text.isNotEmpty
                                          ? _passwordController.text
                                          : null,
                                ),
                              );
                            },
                    child:
                        state is StudentEditing
                            ? const CircularProgressIndicator()
                            : const Text('SAVE CHANGES'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
