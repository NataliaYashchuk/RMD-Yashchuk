import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Increment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IncrementHomePage(),
    );
  }
}

class IncrementHomePage extends StatefulWidget {
  const IncrementHomePage({Key? key}) : super(key: key);

  @override
  _IncrementHomePageState createState() => _IncrementHomePageState();
}

class _IncrementHomePageState extends State<IncrementHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();
  String _message = '';
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_animationController);
  }

  void _increment({int value = 1}) {
    setState(() {
      _counter += value;
      _message = 'Counter incremented by $value';
    });
  }

  void _processInput() {
    final inputText = _controller.text.trim();

    if (inputText.toLowerCase() == 'avada kedavra') {
      _resetCounterWithAnimation();
    } else {
      final inputValue = int.tryParse(inputText);
      if (inputValue != null) {
        _increment(value: inputValue);
      } else {
        setState(() {
          _message = 'Please enter a valid number or "Avada Kedavra".';
        });
      }
    }
    _controller.clear();
  }

  void _resetCounterWithAnimation() {
    _animationController.forward().then((_) {
      setState(() {
        _counter = 0;
        _message = 'Counter reset by spell!';
      });
      _animationController.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Increment App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) => Text(
                'Current Counter Value: $_counter',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: _colorAnimation.value),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _increment(),
              child: const Text('Increment by 1'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a number or "Avada Kedavra"',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processInput,
              child: const Text('Submit Input'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
