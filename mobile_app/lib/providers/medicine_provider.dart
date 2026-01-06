import 'package:flutter/foundation.dart';
import '../models/medicine.dart';
import '../services/api_service.dart';

class MedicineProvider with ChangeNotifier {
  List<Medicine> _medicines = [];
  bool _loading = false;
  String? _error;

  List<Medicine> get medicines => _medicines;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchMedicines() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.fetchMedicines();
      _medicines = (data as List)
          .map((json) => Medicine.fromJson(json))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addMedicine({
    required String name,
    required List<String> times,
    required String posology,
    required int duration,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.createMedicine(
        name: name,
        times: times,
        posology: posology,
        duration: duration,
      );
      final newMedicine = Medicine.fromJson(data);
      _medicines = [newMedicine, ..._medicines];
      _error = null;
    } catch (e) {
      _error = e.toString();
      throw Exception(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> removeMedicine(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.deleteMedicine(id);
      _medicines = _medicines.where((m) => m.id != id).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      throw Exception(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> markTaken(int id, String time) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.markMedicineTaken(id, time);
      final updatedMedicine = Medicine.fromJson(data);
      _medicines = _medicines
          .map((m) => m.id == id ? updatedMedicine : m)
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      throw Exception(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> markCompleted(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.markMedicineCompleted(id);
      final updatedMedicine = Medicine.fromJson(data);
      _medicines = _medicines
          .map((m) => m.id == id ? updatedMedicine : m)
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      throw Exception(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

