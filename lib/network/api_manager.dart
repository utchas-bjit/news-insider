import 'package:news_insider/utils/secrets.dart';

class APIManger {
  static final APIManger _apiManger = APIManger._internal();

  final String apiKey = Sectrets.apiKey;
  final String baseUrl = 'https://newsapi.org';
  final String apiVersion = '/v2';
  final String topHeadlines = '/top-headlines';
  final String everything = '/everything';

  final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  final List<String> languages = [
    'ae', 'ar', 'at', 'au', 'be', 'ba', 'br', 'ca', 'ch', 'cn', 'co', 'cu',
    'cz', 'de', 'eg', 'fr', 'qb', 'qr', 'hk', 'hu', 'id', 'ie', 'il', 'ind',
    'it', 'ip', 'kr', 'lt', 'lv', 'ma', 'mx', 'my', 'ng', 'nl', 'no', 'nz',
    'ph', 'pl', 'pt', 'ro', 'rs', 'ru', 'sa', 'se', 'sq', 'si', 'sk', 'th',
    'tr', 'tw', 'ua', 'us', 've', 'za',
  ];

  factory APIManger.instance() {
    return _apiManger;
  }

  APIManger._internal();

  String getTopHeadlinesUrl(String category, String language) {
    return '$baseUrl$apiVersion$topHeadlines?country=$language&category=$category&apiKey=$apiKey';
  } 
}
