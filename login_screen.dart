import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'registration_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Map<String, String>> registeredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch users from the given URL
  Future<void> _fetchUsers() async {
    final response = await http.get(Uri.parse('https://run.mocky.io/v3/21523da3-b753-4e3e-b760-d47915ce742b'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final usersList = data['users'] as List<dynamic>; // Змінили тип на List<dynamic>
      
      setState(() {
        registeredUsers = usersList.map((user) {
          return {
            'email': user['email']?.toString().trim().toLowerCase() ?? '',
            'password': user['password']?.toString().trim() ?? '',
            'name': user['name']?.toString() ?? '',
          };
        }).toList();
      });
      print('Registered Users: $registeredUsers'); // Debugging output
    } else {
      _showErrorDialog('Не вдалося отримати дані користувачів');
    }
  }

  Future<bool> _validateUser(String email, String password) async {
    if (registeredUsers.isEmpty) {
      return false;
    }

    print('Validating user with email: $email and password: $password');

    return registeredUsers.any(
      (user) {
        bool isValid = user['email'] == email.trim().toLowerCase() && user['password'] == password.trim();
        if (isValid) {
          print('User found: ${user['email']}');
        }
        return isValid;
      },
    );
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  bool _validateLogin() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty) {
      _showErrorDialog('Введіть електронну пошту');
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showErrorDialog('Неправильний формат електронної пошти');
      return false;
    }
    if (password.isEmpty) {
      _showErrorDialog('Введіть пароль');
      return false;
    }
    if (password.length < 6) {
      _showErrorDialog('Пароль повинен містити принаймні 6 символів');
      return false;
    }
    return true;
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
        title: const Text('Увійти до магазину'),
        backgroundColor: const Color.fromARGB(255, 115, 121, 72),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                labelText: 'Електронна пошта',
                controller: emailController,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Пароль',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Увійти',
                onPressed: () async {
                  if (_validateLogin()) {
                    bool isConnected = await _checkInternetConnection();
                    if (!isConnected) {
                      _showErrorDialog('Немає зв’язку з інтернетом');
                    } else {
                      bool userFound = await _validateUser(
                        emailController.text,
                        passwordController.text,
                      );
                      if (userFound) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        _showErrorDialog('Неправильна електронна пошта або пароль');
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(
                        onUserRegistered: (userData) {
                          setState(() {
                            registeredUsers.add(userData);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Не маєте акаунту? Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
