import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:application_medicines/medication.dart';
import 'package:application_medicines/notification_service.dart';

class EditMedicationScreen extends StatelessWidget {
  final MedicationController medicationController =
      Get.find<MedicationController>();
  final NotificationService notificationService =
      Get.find<NotificationService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  final String medicationId;

  final RxBool nameError = false.obs;
  final RxBool dosageError = false.obs;

  EditMedicationScreen({super.key})
      : medicationId = Get.parameters['id'] ?? '' {
    final medication = medicationController.medications
        .firstWhere((med) => med.id == medicationId);

    nameController.text = medication.name;
    dosageController.text = medication.dosage;
    selectedTime.value = TimeOfDay.fromDateTime(medication.time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Medicamento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Eliminar Medicamento'),
                    content: Text(
                        '¿Estás seguro de que deseas eliminar este medicamento?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await medicationController
                              .deleteMedication(medicationId);
                          Navigator.of(context).pop();
                          Get.back();
                        },
                        child: Text('Eliminar',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Medicamento',
                    border: OutlineInputBorder(),
                    errorText:
                        nameError.value ? 'El nombre es requerido' : null,
                  ),
                  onChanged: (_) => nameError.value = false,
                )),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: dosageController,
                  decoration: InputDecoration(
                    labelText: 'Dosis',
                    border: OutlineInputBorder(),
                    errorText:
                        dosageError.value ? 'La dosis es requerida' : null,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (_) => dosageError.value = false,
                )),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                title: const Text('Hora de la Medicación'),
                subtitle: Text(
                  '${selectedTime.value.hour}:${selectedTime.value.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime.value,
                  );
                  if (time != null) {
                    selectedTime.value = time;
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                bool isValid = true;

                if (nameController.text.trim().isEmpty) {
                  nameError.value = true;
                  isValid = false;
                }

                if (dosageController.text.trim().isEmpty) {
                  dosageError.value = true;
                  isValid = false;
                }

                if (isValid) {
                  final now = DateTime.now();
                  final medicationTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    selectedTime.value.hour,
                    selectedTime.value.minute,
                  );

                  final medication = Medication(
                    id: medicationId,
                    name: nameController.text,
                    dosage: dosageController.text,
                    time: medicationTime,
                    userId:
                        (await Get.find<AuthController>().account.get()).$id,
                  );

                  await medicationController.updateMedication(medication);
                  await notificationService.scheduleMedicationNotification(
                    'Es hora de tu medicamento',
                    'Toma ${medication.name} - ${medication.dosage}',
                    medicationTime,
                  );

                  Get.back();
                }
              },
              child: const Text('Guardar Cambios'),
            ),

            // Nueva funcionalidad: Botón para duplicar medicamento
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: Icon(Icons.copy),
              label: Text('Duplicar Medicamento'),
              onPressed: () async {
                final now = DateTime.now();
                final medicationTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime.value.hour,
                  selectedTime.value.minute,
                );

                final medication = Medication(
                  id: '',
                  name: '${nameController.text} (Copia)',
                  dosage: dosageController.text,
                  time: medicationTime,
                  userId: (await Get.find<AuthController>().account.get()).$id,
                );

                await medicationController.addMedication(medication);
                Get.snackbar(
                  'Medicamento duplicado',
                  'Se ha creado una copia del medicamento',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
