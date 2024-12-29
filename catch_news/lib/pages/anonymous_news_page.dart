import 'package:flutter/material.dart';
import 'package:catch_news/viewmodel/article_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/category.dart';
import '../services/auth_service.dart';

class AnonymousNewsPage extends StatefulWidget {
  const AnonymousNewsPage({super.key});

  @override
  State<AnonymousNewsPage> createState() => _AnonymousNewsPageState();
}

class _AnonymousNewsPageState extends State<AnonymousNewsPage> {
  List<Category> categories = [
    Category('general', 'Genel'),
    Category('business', 'İş'),
    Category('entertainment', 'Eğlence'),
    Category('health', 'Sağlık'),
    Category('science', 'Bilim'),
    Category('sports', 'Spor'),
    Category('technology', 'Teknoloji'),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ArticleListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CatchNews'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () async {
            await AuthService().signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: getCategoriesTab(vm),
            ),
          ),
          getWidgetByStatus(vm)
        ],
      ),
    );
  }

  List<GestureDetector> getCategoriesTab(ArticleListViewModel vm) {
    List<GestureDetector> list = [];
    for (int i = 0; i < categories.length; i++) {
      list.add(GestureDetector(
        onTap: () => vm.getNews(categories[i].key),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            categories[i].key.toUpperCase(),
            style: const TextStyle(fontSize: 16),
          ),
        )),
      ));
    }
    return list;
  }

  Widget getWidgetByStatus(ArticleListViewModel vm) {
    switch (vm.status.index) {
      case 2:
        return Expanded(
            child: ListView.builder(
                itemCount: vm.viewModel.articles.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Image.network(vm.viewModel.articles[index].urlToImage ??
                            'https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132484366.jpg'),
                        ListTile(
                          title: Text(
                            vm.viewModel.articles[index].title ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              vm.viewModel.articles[index].description ?? ''),
                        ),
                        OverflowBar(
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                await launchUrl(Uri.parse(
                                    vm.viewModel.articles[index].url ?? ''));
                              },
                              child: const Text(
                                'Habere Git',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }));
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
