import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> _categories = [
    "Genel",
    "İş",
    "Eğlence",
    "Sağlık",
    "Bilim",
    "Spor",
    "Teknoloji",
  ];
  final Map<String, bool> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    for (var category in _categories) {
      _selectedCategories[category] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesabım"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category, color: Colors.blue),
            title: const Text("Favori Kategorilerini Seç"),
            onTap: _showCategorySelectionDialog,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.mail, color: Colors.blue),
            title: const Text("E-postanı Değiştir"),
            onTap: _showEmailChangeDialog,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.blue),
            title: const Text("Şifreni Değiştir"),
            onTap: _showPasswordChangeDialog,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded, color: Colors.red),
            title: const Text("Çıkış Yap"),
            onTap: () async {
            await AuthService().signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
          ),
          const Divider(),
        ],
      ),
    );
  }


  void _showCategorySelectionDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Favori Kategoriler"),
            content: SingleChildScrollView(
              child: Column(
                children: _categories.map((category) {
                  return CheckboxListTile(
                    title: Text(category),
                    value: _selectedCategories[category],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedCategories[category] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await AuthService().saveUserCategories(
                      _selectedCategories.keys
                          .where((category) => _selectedCategories[category] == true)
                          .toList(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Kategoriler başarıyla kaydedildi.")),
                    );

                    Navigator.of(context).pop();
                  } catch (e) {
                    // Hata mesajı göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Kategori kaydetme hatası: $e")),
                    );
                  }
                },
                child: const Text("Kaydet"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("İptal"),
              ),
            ],
          );
        },
      );
    },
  );
}


void _showEmailChangeDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("E-postayı Değiştir"),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Yeni e-posta",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newEmail = emailController.text.trim();
                if (newEmail.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lütfen yeni e-postayı girin.")),
                  );
                  return;
                }
                try {
                  await AuthService().auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("E-posta başarıyla güncellendi.")),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Hata: $e")),
                  );
                }
              },
              child: const Text("Güncelle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
          ],
        );
      },
    );
  }




  void _showPasswordChangeDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Şifreyi Değiştir"),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "Yeni Şifre",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newPassword = passwordController.text.trim();
                if (newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lütfen yeni şifreyi girin.")),
                  );
                  return;
                }
                try {
                  await AuthService().auth.currentUser?.updatePassword(newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Şifre başarıyla güncellendi.")),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Hata: $e")),
                  );
                }
              },
              child: const Text("Güncelle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
          ],
        );
      },
    );
  }
}
