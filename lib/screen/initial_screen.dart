import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    _checkAuth(authController);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services, size: 80, color: Colors.blue),
            SizedBox(height: 24),
            Text(
              'Control de Medicamentos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void _checkAuth(AuthController authController) async {
    await Future.delayed(
      Duration(seconds: 2),
    );
    final isLoggedIn = await authController.checkAuth();

    if (isLoggedIn) {
      Get.offAllNamed('/medications');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
