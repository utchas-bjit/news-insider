import 'package:flutter/material.dart';
import 'package:news_insider/network/network_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewsDetails extends StatelessWidget {
  final Article article;

  const NewsDetails({Key? key, required this.article}) : super(key: key);
  String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
  
    final formattedDate = 'Date : ${dateTime.day}/ ${dateTime.month}/ ${dateTime.year}';
       
    return formattedDate;
  }
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
                'By ${article.author ?? 'Unknown'} | ${article.source?.name ?? 'Unknown'} \n ${formatDate(article.publishedAt  ?? '')}',
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // open in external browser
                    if (await canLaunchUrlString(article.url!)) {
                      await launchUrlString(article.url!);
                    } 
                  },
                  child: const Text('View full article'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
