import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:application_medicines/medication.dart';

class MedicationListScreen extends StatelessWidget {
  final MedicationController medicationController =
      Get.find<MedicationController>();

  MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Medicamentos'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => Get.find<AuthController>().logout(),
            ),
          ],
        ),
        body: Obx(
          () {
            if (medicationController.medications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medication, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No tienes medicamentos registrados',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Agregar medicamento'),
                      onPressed: () => Get.toNamed('/add-medication'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: medicationController.medications.length,
              itemBuilder: (context, index) {
                final medication = medicationController.medications[index];
                return MedicationCard(medication: medication);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed('/add-medication'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(medication.name),
        subtitle: Text('Dosis: ${medication.dosage}'),
        trailing: Text(
          '${medication.time.hour}:${medication.time.minute.toString().padLeft(2, '0')}',
        ),
        onTap: () => Get.toNamed('/edit-medication/${medication.id}'),
      ),
    );
  }
}
