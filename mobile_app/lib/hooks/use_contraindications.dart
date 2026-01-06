import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ContraindicationsData {
  final String? contraindications;
  final String? interactions;
  final String? warnings;

  ContraindicationsData({
    this.contraindications,
    this.interactions,
    this.warnings,
  });
}

class ContraindicationsState {
  final bool loading;
  final String? error;
  final ContraindicationsData? data;

  ContraindicationsState({
    this.loading = false,
    this.error,
    this.data,
  });

  ContraindicationsState copyWith({
    bool? loading,
    String? error,
    ContraindicationsData? data,
  }) {
    return ContraindicationsState(
      loading: loading ?? this.loading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class ContraindicationsHook {
  final _state = ValueNotifier<ContraindicationsState>(
    ContraindicationsState(),
  );

  ValueNotifier<ContraindicationsState> get state => _state;

  Future<void> searchContra(String query) async {
    if (query.trim().isEmpty) return;

    _state.value = _state.value.copyWith(loading: true, error: null, data: null);

    try {
      final encoded = Uri.encodeComponent(query.trim());
      final url = Uri.parse(
        'https://api.fda.gov/drug/label.json?search=openfda.brand_name:$encoded&limit=1',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('No data found');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (!json.containsKey('results') || 
          (json['results'] as List).isEmpty) {
        throw Exception('No label info available');
      }

      final result = (json['results'] as List)[0] as Map<String, dynamic>;

      final data = ContraindicationsData(
        contraindications: _getFirstValue(result, [
          'contraindications',
          'warnings_and_cautions',
          'precautions',
        ]),
        warnings: _getFirstValue(result, [
          'warnings',
          'warnings_and_cautions',
        ]),
        interactions: _getFirstValue(result, [
          'drug_interactions',
          'precautions',
        ]),
      );

      _state.value = _state.value.copyWith(
        loading: false,
        data: data,
        error: null,
      );
    } catch (e) {
      _state.value = _state.value.copyWith(
        loading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        data: null,
      );
    }
  }

  String? _getFirstValue(Map<String, dynamic> result, List<String> keys) {
    for (final key in keys) {
      if (result.containsKey(key)) {
        final value = result[key];
        if (value is List && value.isNotEmpty) {
          return value[0].toString();
        }
      }
    }
    return null;
  }

  void dispose() {
    _state.dispose();
  }
}

