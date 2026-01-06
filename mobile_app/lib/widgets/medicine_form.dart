import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../widgets/snackbar_widget.dart';

class MedicineForm extends StatefulWidget {
  const MedicineForm({super.key});

  @override
  State<MedicineForm> createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _timesController = TextEditingController();
  final _posologyController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _timesController.dispose();
    _posologyController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  bool _validateTime(String time) {
    final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    return regex.hasMatch(time.trim());
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final timeArray = _timesController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      if (timeArray.isEmpty) {
        throw Exception('Please provide at least one time');
      }

      for (final time in timeArray) {
        if (!_validateTime(time)) {
          throw Exception('Invalid time format: $time. Use HH:MM (24-hour).');
        }
      }

      final medicineProvider =
          Provider.of<MedicineProvider>(context, listen: false);
      await medicineProvider.addMedicine(
        name: _nameController.text.trim(),
        times: timeArray,
        posology: _posologyController.text.trim(),
        duration: int.parse(_durationController.text),
      );

      if (mounted) {
        SnackbarWidget.show(
          context,
          'Medicine ${_nameController.text} added!',
          SnackbarType.success,
        );
      }

      _nameController.clear();
      _timesController.clear();
      _posologyController.clear();
      _durationController.clear();
    } catch (e) {
      if (mounted) {
        SnackbarWidget.show(
          context,
          'Error adding medicine: ${e.toString().replaceAll('Exception: ', '')}',
          SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Medicine name is required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _timesController,
              decoration: const InputDecoration(
                labelText: 'Times (comma separated, e.g., 07:00,12:00,18:00)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Times are required';
                }
                final timeArray = value
                    .split(',')
                    .map((t) => t.trim())
                    .where((t) => t.isNotEmpty)
                    .toList();
                if (timeArray.isEmpty) {
                  return 'Please provide at least one time';
                }
                for (final time in timeArray) {
                  if (!_validateTime(time)) {
                    return 'Invalid time format: $time. Use HH:MM (24-hour).';
                  }
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _posologyController,
              decoration: const InputDecoration(
                labelText: 'Posology (e.g., 2 tablets after meal)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Posology is required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (days)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Duration is required';
                }
                final duration = int.tryParse(value);
                if (duration == null || duration < 1) {
                  return 'Duration must be at least 1 day';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

