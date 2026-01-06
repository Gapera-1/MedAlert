import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';
import '../screens/contra_indications_screen.dart';
import '../widgets/snackbar_widget.dart';

class MedicineList extends StatelessWidget {
  const MedicineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicineProvider>(
      builder: (context, medicineProvider, _) {
        if (medicineProvider.loading &&
            medicineProvider.medicines.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (medicineProvider.medicines.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No medicines yet. Add one using the form on the left.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medicine List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: medicineProvider.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicineProvider.medicines[index];
                    return _MedicineCard(medicine: medicine);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MedicineCard extends StatefulWidget {
  final Medicine medicine;

  const _MedicineCard({required this.medicine});

  @override
  State<_MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<_MedicineCard> {
  bool _isProcessing = false;
  String? _processingTime;

  Future<void> _handleMarkTaken(String time) async {
    setState(() {
      _isProcessing = true;
      _processingTime = time;
    });

    try {
      final medicineProvider =
          Provider.of<MedicineProvider>(context, listen: false);
      await medicineProvider.markTaken(widget.medicine.id, time);
    } catch (e) {
      if (mounted) {
        SnackbarWidget.show(
          context,
          'Error marking as taken: ${e.toString().replaceAll('Exception: ', '')}',
          SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingTime = null;
        });
      }
    }
  }

  Future<void> _handleRemove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Medicine'),
        content: Text('Are you sure you want to remove ${widget.medicine.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final medicineProvider =
          Provider.of<MedicineProvider>(context, listen: false);
      await medicineProvider.removeMedicine(widget.medicine.id);
      if (mounted) {
        SnackbarWidget.show(
          context,
          'Medicine removed successfully',
          SnackbarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        SnackbarWidget.show(
          context,
          'Error removing medicine: ${e.toString().replaceAll('Exception: ', '')}',
          SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.medicine.name} — ${widget.medicine.posology}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.medicine.times.map((time) {
                final isTaken = widget.medicine.takenTimes[time] == true;
                final isProcessing =
                    _isProcessing && _processingTime == time;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    if (isTaken)
                      const Text(
                        'Taken ✅',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: isProcessing ? null : () => _handleMarkTaken(time),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                        child: isProcessing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Mark as Taken',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContraIndicationsScreen(
                                medicineName: widget.medicine.name,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                  child: const Text(
                    'View Contra-Indications',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleRemove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Remove Medicine',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

