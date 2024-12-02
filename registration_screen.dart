import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'profile_screen.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Реєстрація'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(labelText: 'Ім\'я'),
            CustomTextField(labelText: 'Email'),
            CustomTextField(labelText: 'Пароль', obscureText: true),
            CustomTextField(labelText: 'Повторіть пароль', obscureText: true),
            CustomButton(
              text: 'Зареєструватися',
              onPressed: () {
                // Після реєстрації переходимо до профілю
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
