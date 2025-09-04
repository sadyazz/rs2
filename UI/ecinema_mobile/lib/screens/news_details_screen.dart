import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/news.dart';

class NewsDetailsScreen extends StatelessWidget {
  final News news;

  const NewsDetailsScreen({
    super.key,
    required this.news,
  });

  String _getType() {
    return news.type?.toLowerCase() ?? 'news';
  }

  bool get _isEvent => _getType() == 'event';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final type = _getType();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(_isEvent ? l10n.event : l10n.news),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          news.title ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isEvent
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _isEvent ? l10n.event : l10n.news,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _isEvent
                                ? colorScheme.primary
                                : colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.publishDate}: ${_formatDate(news.publishDate)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      if (_isEvent && news.eventDate != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              size: 16,
                              color: colorScheme.primary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${l10n.eventDate}: ${_formatDate(news.eventDate)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.primary.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (news.authorName != null && news.authorName!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              news.authorName!,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    news.content ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
} 