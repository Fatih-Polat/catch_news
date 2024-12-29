import 'package:catch_news/pages/register_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş Yap"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "E-posta",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: "Şifre",
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            var user = await AuthService().signInWithEmailAndPassword(
              emailController.text,
              passwordController.text,
            );
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: const Text("Giriş yap"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var user = await AuthService().signInAnonymously();
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/anonymous');
            }
          },
          child: const Text("Misafir olarak devam et"),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: const Text(
            "Bir hesabınız yok mu? Kayıt olun.",
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
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
