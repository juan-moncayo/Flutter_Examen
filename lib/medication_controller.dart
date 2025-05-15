import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import 'package:application_medicines/appwrite_config.dart';
import 'package:application_medicines/medication.dart';

class MedicationController extends GetxController {
  final Databases databases = Databases(AppwriteConfig.getClient());
  final RxList<Medication> medications = <Medication>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getMedications();
  }

  Future<void> addMedication(Medication medication) async {
    try {
      isLoading.value = true;

      // Imprimir información de depuración
      print('Intentando guardar medicamento:');
      print('Database ID: ${AppwriteConfig.databaseId}');
      print('Collection ID: ${AppwriteConfig.collectionId}');
      print('Medication data: ${medication.toJson()}');

      final result = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: ID.unique(),
        data: medication.toJson(),
      );

      print('Documento creado con ID: ${result.$id}');

      await getMedications();
      Get.snackbar(
        'Éxito',
        'Medicamento guardado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error al guardar medicamento: $e');
      Get.snackbar(
        'Error',
        'No se pudo guardar el medicamento: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMedications() async {
    try {
      isLoading.value = true;
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
      );

      print('Documentos obtenidos: ${response.documents.length}');

      medications.value = response.documents.map((doc) {
        print('Documento: ${doc.data}');
        return Medication.fromJson(doc.data, doc.$id);
      }).toList();
    } catch (e) {
      print('Error al obtener medicamentos: $e');
      Get.snackbar(
          'Error', 'No se pudieron cargar los medicamentos: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      isLoading.value = true;
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: medication.id,
        data: medication.toJson(),
      );
      await getMedications();
      Get.snackbar(
        'Éxito',
        'Medicamento actualizado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error al actualizar medicamento: $e');
      Get.snackbar(
          'Error', 'No se pudo actualizar el medicamento: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    try {
      isLoading.value = true;
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: medicationId,
      );
      await getMedications();
      Get.snackbar(
        'Éxito',
        'Medicamento eliminado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error al eliminar medicamento: $e');
      Get.snackbar(
          'Error', 'No se pudo eliminar el medicamento: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
