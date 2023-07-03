import 'package:news_insider/network/api_manager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



//create singletom class
class NetworkManager{
  static final NetworkManager _networkManager = NetworkManager._internal();
  final APIManger _apiManger = APIManger.instance();

  factory NetworkManager.instance() {
    return _networkManager;
  }
  

  NetworkManager._internal();

  Future<NewsApiResponse> getTopHeadlines(String category, String language) async {
    final String url = _apiManger.getTopHeadlinesUrl(category, language);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return NewsApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
  
}

class NewsApiResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsApiResponse({required this.status, required this.totalResults, required this.articles});

  factory NewsApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> articleList = json['articles'];
    final List<Article> articles = articleList.map((articleJson) => Article.fromJson(articleJson)).toList();
    return NewsApiResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articles,
    );
  }
}

class Article {
  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  bool isFavorite = false;

  Article({this.source, this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}

class Source {
  final String? id;
  final String? name;

  Source({this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }
}