import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  const ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
    await prefs.setString('email', emailController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Зміни збережено!')),
    );
  }

  Future<void> deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Видалити акаунт?'),
          content: const Text('Ця дія не може бути скасована.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Видаляємо всі дані користувача

                Navigator.pop(context); // Закриваємо діалог
                Navigator.pop(context); // Повертаємо на попередній екран
              },
              child: const Text('Видалити'),
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
        title: const Text('Профіль покупця'),
        backgroundColor: Colors.brown, // Змінили колір
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ім\'я:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                hintText: 'Введіть ваше ім\'я',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Прізвище:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                hintText: 'Введіть ваше прізвище',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Введіть ваш email',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Зберегти зміни'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Видалити акаунт'),
            ),
          ],
        ),
      ),
    );
  }
}
