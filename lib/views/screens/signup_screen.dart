import 'package:flutter/material.dart';
import '../../controllers/Auth/auth_controller.dart';
import '../../models/user_model.dart';
import '../widgets/reusable_widgets.dart';

class SignupScreen extends StatefulWidget {
  final AuthController authController;

  const SignupScreen({super.key, required this.authController});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const LogoWidget(size: 100),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                label: "Email",
                validator: (value) =>
                    value!.contains('@') ? null : 'Invalid email',
              ),
              CustomTextField(
                controller: _usernameController,
                label: "Username",
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
              CustomTextField(
                controller: _passwordController,
                label: "Password",
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Min 6 characters' : null,
              ),
              CustomTextField(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                obscureText: true,
                validator: (value) => value != _passwordController.text
                    ? 'Passwords must match'
                    : null,
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: 'Sign Up',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newUser = User(
                        email: _emailController.text,
                        username: _usernameController.text,
                        password: _passwordController.text,
                      );

                      await widget.authController.signUp(identifier: newUser.email, password: newUser.password,name: newUser.username);
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User already exists')),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
