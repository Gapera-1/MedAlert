import 'package:flutter/material.dart';
import '../hooks/use_contraindications.dart';

class ContraIndicationsScreen extends StatefulWidget {
  final String medicineName;

  const ContraIndicationsScreen({
    super.key,
    required this.medicineName,
  });

  @override
  State<ContraIndicationsScreen> createState() =>
      _ContraIndicationsScreenState();
}

class _ContraIndicationsScreenState extends State<ContraIndicationsScreen> {
  final _queryController = TextEditingController();
  final _contraindicationsHook = ContraindicationsHook();

  @override
  void initState() {
    super.initState();
    _queryController.text = widget.medicineName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contraindicationsHook.searchContra(widget.medicineName);
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final query = _queryController.text.trim();
    if (query.isNotEmpty) {
      _contraindicationsHook.searchContra(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contra-Indications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    decoration: const InputDecoration(
                      labelText: 'Enter medicine name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _handleSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _handleSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ValueListenableBuilder<ContraindicationsState>(
                valueListenable: _contraindicationsHook.state,
                builder: (context, state, _) {
                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          state.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    );
                  }

                  if (state.data == null) {
                    return Center(
                      child: Text(
                        'No information available. Try another search.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    );
                  }

                  final data = state.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (data.contraindications != null)
                          _InfoCard(
                            title: 'Contra-Indications',
                            content: data.contraindications!,
                          ),
                        if (data.interactions != null) ...[
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Drug Interactions',
                            content: data.interactions!,
                          ),
                        ],
                        if (data.warnings != null) ...[
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Warnings',
                            content: data.warnings!,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const _InfoCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

