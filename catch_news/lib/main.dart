import 'package:catch_news/pages/anonymous_news_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/favorites_page.dart';
import 'pages/login_page.dart';
import 'pages/news_page.dart';
import 'pages/profile_page.dart';
import 'viewmodel/article_list_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticleListViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
    routes: {
      '/login': (context) => LoginPage(),
      '/anonymous': (context) => AnonymousNewsPage(),
      '/home': (context) => const NewsPage(),
      '/favorites': (context) => const FavoritesPage(),
      '/profile': (context) => const ProfilePage(),
    },
    );
  }
}
