import 'package:flutter/material.dart';

void main() {
  runApp(const TextEntryApp());
}

class TextEntryApp extends StatelessWidget {
  const TextEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Entry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _entries = []; // in-memory only, no storage

  void _submit() {
    final text = _controller.text.trim();

    // Basic validation: ignore empty input
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text first.')),
      );
      return;
    }

    setState(() {
      _entries.insert(0, text); // newest entry on top
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Entry App')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Text input field
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(height: 16),

              // Display area
              Expanded(
                child: _entries.isEmpty
                    ? const Center(
                        child: Text(
                          'No entries yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _entries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(_entries[index]),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
