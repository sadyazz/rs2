import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/news_provider.dart';
import '../providers/promotion_provider.dart';
import '../widgets/filter_chips.dart';
import '../widgets/news_item_card.dart';
import '../models/news.dart';
import '../models/promotion.dart';
import 'news_details_screen.dart';
import 'promotion_details_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<News> _news = [];
  List<Promotion> _promotions = [];
  String _selectedFilter = 'all';
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.wait([
        _loadNews(),
        _loadPromotions(),
      ]);
    } catch (e) {
      setState(() {
        _error = l10n.errorLoadingDataMessage(e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNews() async {
    try {
      final newsProvider = NewsProvider();
      final response = await newsProvider.get();
      
      if (response.items != null) {
        setState(() {
          _news = response.items!;
        });
      } else {
        print('Response items is null');
      }
    } catch (e, stackTrace) {
      print('Error loading news: $e');
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _loadPromotions() async {
    try {
      final promotionProvider = PromotionProvider();
      final response = await promotionProvider.get();
      if (response.items != null && response.items!.isNotEmpty) {
        setState(() {
          _promotions = response.items!;
        });
      }
    } catch (e) {
      print('Error loading promotions: $e');
    }
  }

  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  List<Map<String, dynamic>> get filteredItems {
    List<Map<String, dynamic>> items = [];

    if (_selectedFilter == 'all' || _selectedFilter == 'news') {
      items.addAll(_news.where((news) => news.isDeleted != true && news.id != null).map((news) => {
        'id': news.id!.toString(),
        'title': news.title,
        'description': news.content,
        'date': news.publishDate,
        'imageUrl': null,
        'type': 'news',
        'isFeatured': false,
      }));
    }

    if (_selectedFilter == 'all' || _selectedFilter == 'promotions') {
      items.addAll(_promotions.where((p) => 
        p.isDeleted != true && 
        p.endDate != null && 
        p.id != null &&
        p.endDate!.isAfter(DateTime.now())
      ).map((promo) => {
        'id': 'promo_${promo.id!}',
        'title': promo.name,
        'description': promo.description,
        'date': promo.startDate,
        'imageUrl': null,
        'type': 'promotion',
        'isFeatured': false,
      }));
    }

    return items.where((item) => item['date'] != null).toList()
      ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _isLoading 
        ? _buildLoadingState(context)
        : _error != null 
          ? _buildErrorState(context, _error!)
          : _buildContent(context, l10n, colorScheme),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.loadingNotifications,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Greška pri učitavanju',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: Text('Pokušaj ponovo'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n, ColorScheme colorScheme) {
    final items = filteredItems;
    final featuredItems = items.where((item) => item['isFeatured'] == true).toList();
    final latestItems = items.where((item) => item['isFeatured'] != true).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 50),
              FilterChips(
                selectedFilter: _selectedFilter,
                onFilterChanged: _setFilter,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (featuredItems.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.featured,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...featuredItems.map((item) => NewsItemCard(
                    item: item,
                    onTap: () => _onNewsItemTap(item),
                  )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        if (latestItems.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.latestNews,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = latestItems[index];
              return NewsItemCard(
                item: item,
                onTap: () => _onNewsItemTap(item),
              );
            },
            childCount: latestItems.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  void _onNewsItemTap(Map<String, dynamic> item) {
    if (item['type'] == 'news') {
      final news = _news.firstWhere((n) => n.id.toString() == item['id']);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailsScreen(news: news),
        ),
      );
    } else if (item['type'] == 'promotion') {
      final promotionId = int.parse(item['id'].toString().replaceFirst('promo_', ''));
      final promotion = _promotions.firstWhere((p) => p.id == promotionId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PromotionDetailsScreen(promotion: promotion),
        ),
      );
    }
  }
} 