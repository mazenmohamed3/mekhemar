import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/Pages/Auth/sources/auth_datasource.dart';
import '../../controllers/Pages/Home/home_controller.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthDatasource authController;
  final HomeController homeController;

  const HomeScreen({
    super.key,
    required this.authController,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: homeController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
              title: Text('Welcome back ${FirebaseAuth.instance.currentUser?.displayName}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () =>  authController.logout(context),
              ),
            ],
          ),
          body: _getCurrentScreen(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeController.currentIndex,
            onTap: (index) => homeController.changeTab(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }

  Widget _getCurrentScreen() {
    switch (homeController.currentIndex) {
      case 0:
        return Column(
          children: [
            Image.asset(
              'assets/images/banner.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  title: Text('Item ${index + 1}'),
                ),
              ),
            ),
          ],
        );
      case 1:
        return ProfileScreen(authController: authController);
      case 2:
        return const SettingsScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}