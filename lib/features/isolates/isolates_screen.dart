import 'package:flutter/material.dart';
import 'isolate_examples.dart';

class IsolatesScreen extends StatefulWidget {
  const IsolatesScreen({super.key});

  @override
  State<IsolatesScreen> createState() => _IsolatesScreenState();
}

class _IsolatesScreenState extends State<IsolatesScreen> {
  String _result = '';
  bool _isLoading = false;
  final _worker = IsolateWorker();

  @override
  void initState() {
    super.initState();
    _worker.start();
  }

  @override
  void dispose() {
    _worker.dispose();
    super.dispose();
  }

  Future<void> _runExample(String title, Future<String> Function() task) async {
    setState(() {
      _isLoading = true;
      _result = 'Running $title...';
    });

    final stopwatch = Stopwatch()..start();
    try {
      final result = await task();
      stopwatch.stop();
      setState(() {
        _result =
            '$title\n\nResult: $result\n\nTime: ${stopwatch.elapsedMilliseconds}ms';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolates Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _runExample(
                        'Compute - Fibonacci(40)',
                        () async {
                          final result =
                              await ComputeExample.calculateFibonacci(40);
                          return result.toString();
                        },
                      ),
              child: const Text('1. Compute Example'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _runExample(
                        'Basic Isolate - Reverse String',
                        () async {
                          return await BasicIsolateExample.processData(
                              'Hello Flutter Isolates');
                        },
                      ),
              child: const Text('2. Basic Isolate'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _runExample(
                        'Worker - Sum 1 to 10,000,000',
                        () async {
                          final result = await _worker.sumNumbers(10000000);
                          return result.toString();
                        },
                      ),
              child: const Text('3. Worker - Sum'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _runExample(
                        'Worker - Primes up to 10,000',
                        () async {
                          final primes = await _worker.generatePrimes(10000);
                          return '${primes.length} primes found';
                        },
                      ),
              child: const Text('4. Worker - Primes'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _runExample(
                        'JSON Parsing',
                        () async {
                          final json =
                              '[${List.generate(1000, (i) => '{"id":$i,"name":"Item $i"}').join(',')}]';
                          final result = await ComputeExample.parseJson(json);
                          return '${result.length} items parsed';
                        },
                      ),
              child: const Text('5. Parse Large JSON'),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(_result.isEmpty
                        ? 'Tap a button to run an example'
                        : _result),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
