import 'package:flutter/material.dart';
import 'package:news_insider/network/network_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: const NewsList(),
        ),
      ),
    );
  }
}


class NewsListItem extends StatelessWidget {
  final Article article;

  const NewsListItem({Key? key, required this.article}) : super(key: key);

  String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
  
    final formattedDate = 'Date : ${dateTime.day}/${dateTime.month}${dateTime.year}';
       
    return formattedDate;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
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
            Text(
              'By ${article.author ?? 'Unknown'} | ${article.source?.name ?? 'Unknown'} \n ${formatDate(article.publishedAt ?? '')}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
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
    );
  }
}

class NewsDetails extends StatelessWidget {
  final Article article;

  const NewsDetails({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.urlToImage != null)
                Image.network(
                  article.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 8),
              Text(
                article.title ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'By ${article.author ?? 'Unknown'} | ${article.source?.name ?? 'Unknown'} \n ${article.publishedAt ?? ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                child: Text(
                  article.description ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}


class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);

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
    final newsApiResponse =
        await _networkManager.getTopHeadlines('business', 'us');
    setState(() {
      _newsApiResponse = newsApiResponse;
    });
  }
  //function for date format: 2021-09-12T12:00:00Z conver this to 12 Sep 2021
  



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
