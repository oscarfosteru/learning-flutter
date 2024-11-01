import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginTrue extends StatefulWidget {
  const LoginTrue({Key? key}) : super(key: key);

  @override
  State<LoginTrue> createState() => _LoginTrueState();
}

class _LoginTrueState extends State<LoginTrue> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icon.png'), // Imagen de tu aplicación
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'ejemplo@gmail.com',
                  label: Text('Correo electrónico'),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _email,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  icon: const Icon(Icons.lock),
                  label: const Text('Contraseña'),
                  labelStyle: const TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                controller: _password,
                obscureText: _obscureText,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _email.text,
                        password: _password.text,
                      );

                      // Inicia sesión exitosamente
                      print('Usuario inició sesión: ${credential.user?.email}');
                      // Navegar a otra pantalla después de iniciar sesión
                      Navigator.pushReplacementNamed(context, '/menu');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print(
                            'No se encontró ningún usuario con ese correo electrónico.');
                      } else if (e.code == 'wrong-password') {
                        print('Contraseña incorrecta.');
                      } else {
                        print('Error: $e');
                      }
                    }
                  },
                  child: const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: 16),

              // Texto para crear una cuenta
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    color: Color.fromARGB(255, 98, 98, 98)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Asegúrate de definir la pantalla de registro y las rutas en tu MaterialApp
