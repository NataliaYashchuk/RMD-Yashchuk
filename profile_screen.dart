import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профіль користувача'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'), // Додайте зображення в assets
            ),
            SizedBox(height: 20),
            Text(
              'Ім\'я користувача',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Перейти до головної',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
