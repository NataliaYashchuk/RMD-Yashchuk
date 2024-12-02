import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final Function(Map<String, String>) onUserRegistered;

  RegistrationScreen({super.key, required this.onUserRegistered});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
        backgroundColor: Colors.brown, // Колір AppBar для магазину
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              labelText: 'Ім\'я',
              controller: firstNameController,
              obscureText: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Прізвище',
              controller: lastNameController,
              obscureText: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Email',
              controller: emailController,
              obscureText: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Пароль',
              obscureText: true,
              controller: passwordController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Підтвердити пароль',
              obscureText: true,
              controller: confirmPasswordController,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Зареєструватися',
              onPressed: () async {
                if (_validateRegistration(context)) {
                  bool userExists = await _checkUserExists(emailController.text);
                  if (userExists) {
                    _showErrorDialog(context, 'Ця електронна пошта вже зареєстрована');
                  } else {
                    await _saveUserData();
                    onUserRegistered({
                      'email': emailController.text,
                      'password': passwordController.text,
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                    });
                    _showSuccessDialog(context, 'Реєстрація успішна!');
                    _clearTextFields();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateRegistration(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;

    if (firstName.isEmpty) {
      _showErrorDialog(context, 'Введіть ім\'я');
      return false;
    }
    if (lastName.isEmpty) {
      _showErrorDialog(context, 'Введіть прізвище');
      return false;
    }
    if (email.isEmpty) {
      _showErrorDialog(context, 'Введіть електронну пошту');
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showErrorDialog(context, 'Неправильний формат електронної пошти');
      return false;
    }
    if (password.isEmpty) {
      _showErrorDialog(context, 'Введіть пароль');
      return false;
    }
    if (password.length < 6) {
      _showErrorDialog(context, 'Пароль повинен містити принаймні 6 символів');
      return false;
    }
    if (confirmPassword.isEmpty) {
      _showErrorDialog(context, 'Підтвердіть пароль');
      return false;
    }
    if (confirmPassword != password) {
      _showErrorDialog(context, 'Паролі не співпадають');
      return false;
    }
    return true;
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Зберігання даних
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
  }

  Future<bool> _checkUserExists(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') == email; // Перевіряємо, чи існує email
  }

  void _clearTextFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }

  void _showErrorDialog(BuildContext context, String message) {
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

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Успіх'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('ОК'),
              onPressed: () {
                Navigator.pop(context); // Закриваємо діалог і повертаємося до логіну
              },
            ),
          ],
        );
      },
    );
  }
}

