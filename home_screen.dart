import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Lego model
class Lego {
  final String title;
  final String description;
  final String image;
  final double price;

  Lego({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
  });

  factory Lego.fromJson(Map<String, dynamic> json) {
    return Lego(
      title: json['name'] is String ? json['name'] : 'Без назви',
      description: json['description'] is String ? json['description'] : 'Без опису',
      image: json['image'] is String ? json['image'] : '',
      price: json['price'] is double ? json['price'] : 0.0, // Handle price as double
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Lego> items = [];
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool connected = result != ConnectivityResult.none;
      if (connected != _isConnected) {
        setState(() {
          _isConnected = connected;
        });
        if (!_isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Відсутній зв’язок з інтернетом')),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    try {
      final response = await http.get(Uri.parse('https://run.mocky.io/v3/f9f323f6-9b6e-46ad-aa1b-ad913279615d'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'products' field is present and not null
        final List<dynamic> legoData = data['products'] != null ? List.from(data['products']) : [];

        setState(() {
          items = legoData.map((item) => Lego.fromJson(item)).toList();
        });
      } else {
        _showErrorDialog('Не вдалося отримати дані з API');
      }
    } catch (e) {
      _showErrorDialog('Помилка під час отримання даних: $e');
    }
  }

  Future<void> _logout(BuildContext context) async {
    // Clearing session data and navigating back to login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ви успішно вийшли з системи')));
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    // Navigating to profile screen only if connected
    if (_isConnected) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String firstName = prefs.getString('firstName') ?? 'Невідомо';
      String lastName = prefs.getString('lastName') ?? 'Невідомо';
      String email = prefs.getString('email') ?? 'Не вказано';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            firstName: firstName,
            lastName: lastName,
            email: email,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Перегляд профілю недоступний без інтернету')),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Помилка'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('ОК'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lego screen'),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show a loading spinner while items are being fetched
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.image,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.description),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: _isConnected
                        ? () {
                            // Handle navigation
                          }
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToProfile(context),
        backgroundColor: _isConnected ? Colors.purple : Colors.grey,
        child: const Icon(Icons.person),
      ),
    );
  }
}
