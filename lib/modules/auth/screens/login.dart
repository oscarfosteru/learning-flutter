import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginTrue extends StatefulWidget {
  const LoginTrue({Key? key}) : super(key: key);

  @override
  _LoginTrueState createState() => _LoginTrueState();
}

class _LoginTrueState extends State<LoginTrue> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  // Método para iniciar sesión
  Future<void> _iniciarSesion(String emailInput, String passInput) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailInput,
        password: passInput,
      );

      // Navega a la pantalla principal después del login exitoso
      Navigator.pushReplacementNamed(context, '/menu');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _mostrarMensaje('No se encontró ningún usuario para ese correo electrónico.');
      } else if (e.code == 'wrong-password') {
        _mostrarMensaje('Contraseña incorrecta.');
      } else {
        _mostrarMensaje('Error: ${e.message}');
      }
    }
  }

  // Método para mostrar mensajes en un SnackBar
  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de email
            TextField(
              controller: _controllerEmail,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),

            // Campo de contraseña
            TextField(
              controller: _controllerPass,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 24),

            // Botón de iniciar sesión
            ElevatedButton(
              onPressed: () {
                _iniciarSesion(
                  _controllerEmail.text.trim(),
                  _controllerPass.text.trim(),
                );
              },
              child: const Text("Iniciar Sesión"),
            ),
            const SizedBox(height: 16),

            // Botón para ir al registro
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Crear Cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}

// Clase de registro básica
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Cuenta")),
      body: Center(
        child: const Text("Aquí va la pantalla de registro"),
      ),
    );
  }
}
