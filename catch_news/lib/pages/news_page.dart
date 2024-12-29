import 'package:flutter/material.dart';
import 'package:catch_news/viewmodel/article_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/category.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NewsPageContent(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorilerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hesabım',
          ),
        ],
      ),
    );
  }
}

class NewsPageContent extends StatelessWidget {
  const NewsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ArticleListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CatchNews'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _getCategoriesTab(vm),
            ),
          ),
          _getWidgetByStatus(vm),
        ],
      ),
    );
  }

  List<GestureDetector> _getCategoriesTab(ArticleListViewModel vm) {
    final categories = [
      Category('general', 'Genel'),
      Category('business', 'İş'),
      Category('entertainment', 'Eğlence'),
      Category('health', 'Sağlık'),
      Category('science', 'Bilim'),
      Category('sports', 'Spor'),
      Category('technology', 'Teknoloji'),
    ];

    return categories
        .map(
          (category) => GestureDetector(
            onTap: () => vm.getNews(category.key),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  category.key.toUpperCase(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _getWidgetByStatus(ArticleListViewModel vm) {
    switch (vm.status.index) {
      case 2:
        return Expanded(
          child: ListView.builder(
            itemCount: vm.viewModel.articles.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    Image.network(
                      vm.viewModel.articles[index].urlToImage ??
                          'https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132484366.jpg',
                    ),
                    ListTile(
                      title: Text(
                        vm.viewModel.articles[index].title ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(vm.viewModel.articles[index].description ?? ''),
                    ),
                    OverflowBar(
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            await launchUrl(
                              Uri.parse(
                                vm.viewModel.articles[index].url ?? '',
                              ),
                            );
                          },
                          child: const Text(
                            'Habere Git',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
