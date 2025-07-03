import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'models/article.dart';

void main() {
  runApp(const InsightSphereApp());
}

class InsightSphereApp extends StatelessWidget {
  const InsightSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F131A),
      ),
      home: const InsightHomeScreen(),
    );
  }
}

class ApiService {
  final String apiKey;
  final String baseUrl = 'https://newsapi.org/v2';

  ApiService({required this.apiKey});

  Future<List<Article>> fetchTopHeadlines({String? category}) async {
    String url = '$baseUrl/top-headlines?apiKey=$apiKey&country=us';
    if (category != null && category != 'all') {
      url += '&category=$category';
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> articlesJson = jsonResponse['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Article>> fetchEverything({String? q}) async {
    String url = '$baseUrl/everything?apiKey=$apiKey';
    if (q != null && q.isNotEmpty) {
      url += '&q=$q';
    } else {
      url += '&q=united states';
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> articlesJson = jsonResponse['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

class InsightHomeScreen extends StatefulWidget {
  const InsightHomeScreen({super.key});

  @override
  _InsightHomeScreenState createState() => _InsightHomeScreenState();
}

class _InsightHomeScreenState extends State<InsightHomeScreen> {
  final ApiService apiService =
      ApiService(apiKey: 'acbc3b69ac87481fb992a0c8fa012f83');
  List<Article> articles = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedCategory = 'all';
  String getWelcomeMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 24) return 'Good Evening';
    return 'Good Night';
  }

  String getFormattedDateTime() {
    final now = DateTime.now();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final dayName = days[now.weekday - 1];
    final month = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][now.month - 1];
    final time =
        '${now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'} IST';
    return '$dayName, $month ${now.day}, ${now.year} | $time';
  }

  Future<void> fetchArticles() async {
    setState(() => isLoading = true);
    if (selectedCategory != 'all' && searchQuery.isEmpty) {
      articles = await apiService.fetchTopHeadlines(category: selectedCategory);
    } else if (searchQuery.isNotEmpty) {
      articles = await apiService.fetchEverything(q: searchQuery);
    } else {
      articles = await apiService.fetchTopHeadlines();
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void onRefresh() {
    fetchArticles();
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    fetchArticles();
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F131A), Color(0xFF1A2332)],
                stops: [0.0, 1.0],
              ),
            ),
            child: ListView(),
          ),
          // Cosmic Effects
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.2, 0.5),
                radius: 0.5,
                colors: [
                  const Color(0x1900FFFF).withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.8, 0.2),
                radius: 0.5,
                colors: [
                  const Color(0x19FF00FF).withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.4, 0.8),
                radius: 0.5,
                colors: [
                  const Color(0x198A2BE2).withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: ListView(
              padding: const EdgeInsets.all(4.0),
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.white.withOpacity(0.1))),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              color: Colors.cyan, size: 32),
                          const SizedBox(width: 12),
                          Text(
                            'InsightSphere',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.cyan.withOpacity(0.8),
                                  offset: const Offset(0, 0),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[400], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Search news...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          onChanged: onSearch,
                        ),
                      ),
                    ],
                  ),
                ),
                // Category Filters
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  alignment: WrapAlignment.center,
                  children: [
                    CategoryChip(
                        label: 'All',
                        isActive: selectedCategory == 'all',
                        onTap: () => onCategorySelected('all')),
                    CategoryChip(
                        label: 'Technology',
                        isActive: selectedCategory == 'technology',
                        onTap: () => onCategorySelected('technology')),
                    CategoryChip(
                        label: 'Sports',
                        isActive: selectedCategory == 'sports',
                        onTap: () => onCategorySelected('sports')),
                    CategoryChip(
                        label: 'Business',
                        isActive: selectedCategory == 'business',
                        onTap: () => onCategorySelected('business')),
                    CategoryChip(
                        label: 'Health',
                        isActive: selectedCategory == 'health',
                        onTap: () => onCategorySelected('health')),
                    CategoryChip(
                        label: 'Science',
                        isActive: selectedCategory == 'science',
                        onTap: () => onCategorySelected('science')),
                    CategoryChip(
                        label: 'Entertainment',
                        isActive: selectedCategory == 'entertainment',
                        onTap: () => onCategorySelected('entertainment')),
                  ],
                ),
                // Welcome Message
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Welcome, ${getWelcomeMessage()}!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.cyan.withOpacity(0.8),
                          offset: const Offset(0, 0),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                // Date and Time
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    getFormattedDateTime(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                // News Cards in Rows
                if (isLoading)
                  const Center(
                      child: CircularProgressIndicator(color: Colors.cyan))
                else if (articles.isEmpty)
                  const Center(
                      child: Text('No articles found',
                          style: TextStyle(color: Colors.white)))
                else
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: List.generate(
                      (articles.length / 2).ceil() * 2,
                      (index) => index < articles.length
                          ? NewsCard(
                              article: articles[index],
                              width:
                                  (MediaQuery.of(context).size.width - 24) / 2)
                          : const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryChip(
      {super.key,
      required this.label,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.cyan.withOpacity(0.05)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
              color: isActive ? Colors.cyan : Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.5),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.cyan : Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Article article;
  final double width;

  const NewsCard({super.key, required this.article, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(article: article),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: 200,
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border(left: BorderSide(color: Colors.cyan, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 111,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  article.urlToImage ?? 'https://via.placeholder.com/150x100',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/app_logo.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.1),
                border: Border.all(color: Colors.cyan.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NewsAPI.org',
                style: TextStyle(color: Colors.cyan, fontSize: 8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              article.title ?? 'No title',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              article.description ?? 'No description',
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  Future<void> _launchURL() async {
    if (article.url != null && article.url!.isNotEmpty) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F131A), Color(0xFF1A2332)],
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          article.urlToImage ??
                              'https://via.placeholder.com/300x300',
                          height: 138,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/app_logo.png',
                              height: 138,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title ?? 'No title',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.description != null &&
                                article.description!.isNotEmpty
                            ? article.description!
                            : (article.content != null &&
                                    article.content!.isNotEmpty
                                ? article.content!
                                : 'No description available'),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Published: ${article.publishedAt ?? 'N/A'} by ${article.author ?? 'Unknown'}',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TextButton(
                          onPressed:
                              article.url != null && article.url!.isNotEmpty
                                  ? _launchURL
                                  : null,
                          child: Text('Read more',
                              style: TextStyle(color: Colors.cyan)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
