import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Node App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(title: 'Flutter Node App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = 'Warte auf Server-Antwort...';

  // Dynamische Backend-URL basierend auf der Umgebung
  String get _backendUrl {
    // Wenn wir im Browser sind, verwenden wir localhost
    if (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1') {
      return 'http://localhost:3000';
    }
    // Ansonsten verwenden wir den Docker-Service-Namen
    return 'http://backend:3000';
  }

  Future<void> _testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_backendUrl/api/test'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _message = data['message'];
        });
      } else {
        setState(() {
          _message = 'Fehler: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Fehler: $e';
      });
    }
  }

  void _resetConnection() {
    setState(() {
      _message = 'Warte auf Server-Antwort...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Server-Verbindung testen:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(_message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _testConnection,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Verbindung testen'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetConnection,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Zurücksetzen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
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
