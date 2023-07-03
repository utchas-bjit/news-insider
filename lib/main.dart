import 'package:flutter/material.dart';
import 'package:news_insider/network/network_manager.dart';
import 'package:news_insider/news_details.dart';
import 'package:news_insider/network/api_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedCategory = 'business';

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Insider',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('News Insider'),
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 231, 229, 229).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Categories(
                  categories: APIManger.instance().categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _onCategorySelected,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: NewsList(selectedCategory: _selectedCategory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  final String selectedCategory;

  const NewsList({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  NewsApiResponse? _newsApiResponse;
  final NetworkManager _networkManager = NetworkManager.instance();

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final newsApiResponse = await _networkManager.getTopHeadlines(
        widget.selectedCategory.toLowerCase(), 'us');
    setState(() {
      _newsApiResponse = newsApiResponse;
    });
  }

  String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);

    final formattedDate =
        'Date : ${dateTime.day}/ ${dateTime.month}/ ${dateTime.year}';

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return _newsApiResponse == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _newsApiResponse!.articles.length,
            itemBuilder: (BuildContext context, int index) {
              final article = _newsApiResponse!.articles[index];
              return NewsListItem(article: article);
            },
          );
  }
}

class NewsListItem extends StatelessWidget {
  final Article article;

  const NewsListItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.urlToImage != null)
                Image.network(
                  article.urlToImage!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 8),
              Text(
                article.title ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Text(
              //   'By ${article.author ?? 'Unknown'} | ${article.source?.name ?? 'Unknown'} \n ${formatDate(article.publishedAt ?? '')}',
              //   style: const TextStyle(
              //     fontSize: 14,
              //     color: Colors.grey,
              //   ),
              // ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetails(article: article),
                    ),
                  );
                },
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const Categories({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final category in categories)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                onCategorySelected(category);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedCategory == category ? Colors.green : null,
              ),
              child: Text(category),
            ),
          ),
      ],
    );
  }
}