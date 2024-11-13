import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  void _onItemTapped() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial', true);
    Navigator.pushReplacementNamed(context, '/menu');
  }

  void _nextTapped() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial', false);
    Navigator.pushReplacementNamed(context, '/menu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            Image.network(
              'https://via.placeholder.com/500',
              width: double.infinity,
              height: 256,
            ),
            const Center(
              child: Text(
                'Bienvenido a la aplicación',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: _nextTapped, child: const Text('Continuar')),
            InkWell(onTap: _onItemTapped, child: const Text('No mostrar'))
          ],
        ),
      ),
    );
  }
}