import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import 'package:application_medicines/appwrite_config.dart';
import 'package:appwrite/models.dart';

class AuthController extends GetxController {
  final Account account = Account(AppwriteConfig.getClient());
  final Rx<User?> user = Rx<User?>(null);

  Future<bool> checkAuth() async {
    try {
      final userData = await account.get();
      user.value = userData;
      print('Usuario autenticado: ${userData.$id}');
      return true;
    } catch (e) {
      print('Error de autenticación: $e');
      return false;
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      await login(email, password);
    } catch (e) {
      print('Error al crear cuenta: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final userData = await account.get();
      user.value = userData;
      print('Usuario logueado: ${userData.$id}');
      Get.offAllNamed('/medications');
    } catch (e) {
      print('Error al iniciar sesión: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      user.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error al cerrar sesión: $e');
      Get.snackbar('Error', e.toString());
    }
  }
}
