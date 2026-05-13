import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/bias_slider.dart';
import '../widgets/article_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;
  String _error = '';
  double _biasValue = 0.0;
  String _selectedRegion = 'US';

  final List<String> _regions = ['US', 'Australia', 'China', 'Pacific'];

  void _filterArticles() {
  setState(() {
    // Always show all articles
    _filteredArticles = List.from(_articles);

    // Sort by how close they are to the slider value
    _filteredArticles.sort((a, b) {
      double scoreA = _getRegionalScore(a);
      double scoreB = _getRegionalScore(b);

      double diffA = (scoreA - _biasValue).abs();
      double diffB = (scoreB - _biasValue).abs();

      return diffA.compareTo(diffB);
    });
  });
}

  double _getRegionalScore(Article article) {
    if (article.regionalScores == null) return 0.0;
    switch (_selectedRegion) {
      case 'Australia':
        return article.regionalScores!.ausBias;
      case 'China':
        return article.regionalScores!.chinaBias;
      case 'Pacific':
        return article.regionalScores!.pacificBias;
      default:
        return article.regionalScores!.usBias;
    }
  }

  Future<void> _searchNews() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final articles = await ApiService.fetchNews(_searchController.text);
      setState(() {
        _articles = articles;
        _filteredArticles = articles;
        _isLoading = false;
      });
      _filterArticles();
    } catch (e) {
      setState(() {
        _error = 'Failed to load news. Is the server running?';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
  backgroundColor: const Color(0xFF161B22),
  title: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Herekam',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'harim nao • listen now',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    ],
  ),
),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search a topic...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF161B22),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    ),
                    onSubmitted: (_) => _searchNews(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF238636),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Region Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _regions.map((region) {
                bool isSelected = _selectedRegion == region;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedRegion = region);
                    _filterArticles();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF238636)
                          : const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      region,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Bias Slider
          BiasSlider(
  value: _biasValue,
  onChanged: (val) {
    setState(() {
      _biasValue = val;
      _filterArticles();
    });
  },
),

          const SizedBox(height: 16),

          // Articles List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : _error.isNotEmpty
                    ? Center(
                        child: Text(
                          _error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _filteredArticles.isEmpty
                        ? const Center(
                            child: Text(
                              'Search a topic to see articles',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredArticles.length,
                            itemBuilder: (context, index) {
                              return ArticleCard(
                                article: _filteredArticles[index],
                                region: _selectedRegion,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}