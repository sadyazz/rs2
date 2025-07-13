import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/news.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/news_provider.dart';
import 'package:ecinema_desktop/screens/edit_news_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late NewsProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<NewsProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNews();
    });
  }

  SearchResult<News>? result;
  int currentPage = 0;
  int pageSize = 18;
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  bool isActive = true;
  bool includeDeleted = false;
  DateTime? fromPublishDate;
  DateTime? toPublishDate;
  int? authorId;

  Future<void> _loadNews() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      var filter = <String, dynamic>{
        'page': currentPage,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'includeDeleted': includeDeleted,
      };
      
      if (fromPublishDate != null) {
        filter['fromPublishDate'] = fromPublishDate!.toIso8601String();
      }
      
      if (toPublishDate != null) {
        filter['toPublishDate'] = toPublishDate!.toIso8601String();
      }
      
      if (authorId != null) {
        filter['authorId'] = authorId;
      }
      
      print('Loading news with filter: $filter');
      result = await provider.get(filter: filter);
      print('News result: ${result?.items?.length} items');
      setState(() {
        result = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading news: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _searchNews() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      var filter = <String, dynamic>{
        'page': 0,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'isActive': isActive,
        'includeDeleted': includeDeleted,
      };
      
      if (_searchController.text.isNotEmpty) {
        filter["title"] = _searchController.text;
      }
      
      if (fromPublishDate != null) {
        filter['fromPublishDate'] = fromPublishDate!.toIso8601String();
      }
      
      if (toPublishDate != null) {
        filter['toPublishDate'] = toPublishDate!.toIso8601String();
      }
      
      if (authorId != null) {
        filter['authorId'] = authorId;
      }
      
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
        currentPage = 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching news: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToNextPage() {
    if (result != null && result!.items!.length == pageSize) {
      setState(() {
        currentPage++;
      });
      _loadNews();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _loadNews();
    }
  }

  void _resetPagination() {
    setState(() {
      currentPage = 0;
      fromPublishDate = null;
      toPublishDate = null;
      authorId = null;
    });
    _loadNews();
  }

  void _deleteNews(News news) async {
    final l10n = AppLocalizations.of(context)!;
    final newsTitle = news.title;
    
          final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.deleteNewsArticle),
          content: Text(l10n.confirmDeleteNewsArticle(newsTitle ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.close),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.softDelete(news.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.newsArticleDeletedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        _resetPagination();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToDeleteNewsArticle),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _restoreNews(News news) async {
    final l10n = AppLocalizations.of(context)!;
    final newsTitle = news.title;
    
          final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.restoreNewsArticle),
          content: Text(l10n.confirmRestoreNewsArticle(newsTitle ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.close),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.restore(news.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.newsArticleRestoredSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        _resetPagination();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToRestoreNewsArticle),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(l10n.newsArticles,
      Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
        child: Column(
          children: [
            _buildSearch(),
            _buildResultView()
          ],
        ),
      ),
      showDrawer: false,
    );
  }

  Widget _buildSearch() {
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField( 
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.search,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2.5),
                ),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              await _searchNews();
            },
            icon: const Icon(Icons.search, size: 18),
            label: Text(l10n.search),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  bool localIsActive = isActive;
                  bool localIncludeDeleted = includeDeleted;
                  DateTime? localFromPublishDate = fromPublishDate;
                  DateTime? localToPublishDate = toPublishDate;
                  int? localAuthorId = authorId;
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 80),
                      content: SizedBox(
                        width: 400,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(l10n.isActive),
                                const SizedBox(width: 8),
                                Switch(
                                  value: localIsActive,
                                  onChanged: (val) {
                                    setState(() => localIsActive = val);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  l10n.includeDeleted,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Switch(
                                  value: localIncludeDeleted,
                                  onChanged: (val) {
                                    setState(() => localIncludeDeleted = val);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: FormBuilderDateTimePicker(
                                    name: 'fromPublishDate',
                                    decoration: InputDecoration(
                                      labelText: l10n.fromPublishDate,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.calendar_today),
                                    ),
                                    inputType: InputType.date,
                                    initialValue: localFromPublishDate,
                                    onChanged: (value) {
                                      setState(() => localFromPublishDate = value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: FormBuilderDateTimePicker(
                                    name: 'toPublishDate',
                                    decoration: InputDecoration(
                                      labelText: l10n.toPublishDate,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.calendar_today),
                                    ),
                                    inputType: InputType.date,
                                    initialValue: localToPublishDate,
                                    onChanged: (value) {
                                      setState(() => localToPublishDate = value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              localIsActive = true;
                              isActive = true;
                              localIncludeDeleted = false;
                              includeDeleted = false;
                              localFromPublishDate = null;
                              fromPublishDate = null;
                              localToPublishDate = null;
                              toPublishDate = null;
                              localAuthorId = null;
                              authorId = null;
                            });
                          },
                          child: Text('Reset'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.close),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isActive = localIsActive;
                              includeDeleted = localIncludeDeleted;
                              fromPublishDate = localFromPublishDate;
                              toPublishDate = localToPublishDate;
                              authorId = localAuthorId;
                            });
                            await _searchNews();
                            Navigator.pop(context);
                          },
                          child: Text('Apply'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt_outlined),
            label: Text('Filters'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditNewsScreen(),
                ),
              );
              if (result == true) {
                _resetPagination();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.addNews),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                l10n.loadingNewsArticles,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result == null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                l10n.noNewsArticlesLoaded,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result!.items!.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                l10n.noNewsArticlesFound,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                l10n.tryAdjustingSearchCriteria,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 5),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: result!.items!.length,
                itemBuilder: (context, index) {
                  final news = result!.items![index];
                  return _buildNewsCard(news);
                },
              ),
            ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildNewsCard(News news) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditNewsScreen(news: news),
          ),
        );
        if (result == true) {
          _resetPagination();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.article,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  if (news.isDeleted == true)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.deleted,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title ?? 'Untitled',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    if (news.authorName != null) ...[
                      Text(
                        'By ${news.authorName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                    ],
                    Text(
                      news.content != null && news.content!.isNotEmpty 
                          ? news.content!.length > 35 
                                                        ? '${news.content!.substring(0, 35)}...'
                          : news.content!
                      : l10n.noContent,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: news.isActive == true 
                                ? Colors.green[100] 
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            news.isActive == true ? l10n.active : l10n.inactive,
                            style: TextStyle(
                              color: news.isActive == true 
                                  ? Colors.green[700] 
                                  : Colors.red[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditNewsScreen(news: news),
                                  ),
                                );
                                if (result == true) {
                                  _resetPagination();
                                }
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                if (news.isDeleted == true) {
                                  _restoreNews(news);
                                } else {
                                  _deleteNews(news);
                                }
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  news.isDeleted == true ? Icons.restore : Icons.delete,
                                  size: 16,
                                  color: news.isDeleted == true 
                                      ? Colors.green 
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final l10n = AppLocalizations.of(context)!;
    if (result == null) return const SizedBox.shrink();
    
    final totalCount = result!.totalCount ?? 0;
    final currentItems = result!.items!.length;
    final hasNextPage = currentItems == pageSize;
    final hasPreviousPage = currentPage > 0;
    final totalPages = (totalCount / pageSize).ceil();
    
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: hasPreviousPage 
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasPreviousPage ? _goToPreviousPage : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 14,
                        color: hasPreviousPage 
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: hasPreviousPage 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${currentPage + 1} / $totalPages',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$currentItems of $totalCount',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: hasNextPage 
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasNextPage ? _goToNextPage : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: hasNextPage 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: hasNextPage 
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 