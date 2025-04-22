
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/features/daily_tracker/features/authentication/presentation/cubit/auth_cubit.dart';

import '../../../../core/widgets/text_field.dart';
import '../../core/daily_tracker_router_module.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: 'krishnajiyedlapalli60@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '123456');

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Perform login logic
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      var status = await context.read<AuthCubit>().validateUserCredentials(email, password);
      if(status && mounted) {
        GoRouter.of(context).go(DailyTrackerRouterModule.profilesPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('asset/daily_tracker/auth/landscape_backgroun.png',), opacity: 0.4)
      ),
      child: Card(
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          width: MediaQuery.of(context).size.width/2.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Title(color: Colors.black, child: const Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                ),
                // Email Field
                CustomTextField(controller: _emailController, label: 'Email', ),
                SizedBox(height: 16),
                CustomTextField(controller: _passwordController, label: 'Password',),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
