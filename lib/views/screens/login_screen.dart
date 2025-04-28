import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/Auth/auth_controller.dart';
import '../../controllers/Auth/login_controller.dart';
import '../widgets/reusable_widgets.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  final LoginController loginController;

  const LoginScreen({super.key, required this.authController, required this.loginController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _attemptAutoLogin();
  // }
  //
  // Future<void> _attemptAutoLogin() async {
  //   final savedData = await widget.authController.loadSavedLogin();
  //   final email = savedData['email'];
  //   final password = savedData['password'];
  //
  //   if (email != null && password != null) {
  //     try {
  //       await widget.authController.login(
  //         identifier: email,
  //         password: password,
  //         rememberMe: true,
  //       );
  //       Navigator.pushReplacementNamed(context, '/home');
  //     } catch (e) {
  //       // If saved credentials are wrong, fallback to normal login screen
  //       print('Auto-login failed: $e');
  //     }
  //   }
  // }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 20,
                children: [
                  const LogoWidget(size: 200),
                  const Text('Mekhemar', style: TextStyle(fontSize: 42), textAlign: TextAlign.center),
                  CustomTextField(
                    focus: widget.loginController.emailFocus,
                    controller: _identifierController,
                    label: "Email or Username",
                    validator: (value) => value!.isEmpty ? 'Required field' : null,
                  ),
                  CustomTextField(
                    focus: widget.loginController.passwordFocus,
                    controller: _passwordController,
                    label: "Password",
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) => setState(() => _rememberMe = value!),
                      ),
                      const Text('Remember Me'),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  CustomButton(
                    text: 'Login',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await widget.authController.login(
                            rememberMe: _rememberMe,
                            identifier: _identifierController.text,
                            password: _passwordController.text,
                          );
                          Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                  ),
                  CustomButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    text: 'Create Account',
                  ),
                  ElevatedButton.icon(
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.white,
                    //   foregroundColor: Colors.black,
                    //   minimumSize: const Size(double.infinity, 50),
                    //   side: const BorderSide(color: Colors.grey),
                    // ),
                    icon: Image.asset('assets/images/google.png', height: 24), // Optional: add your Google logo
                    label: const Text("Sign in with Google"),
                    onPressed: () async {
                      try {
                        await widget.authController.signInWithGoogle();
                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}