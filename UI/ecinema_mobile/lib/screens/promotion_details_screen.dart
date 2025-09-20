import 'package:flutter/material.dart';
import 'package:ecinema_mobile/l10n/app_localizations.dart';
import '../models/promotion.dart';

class PromotionDetailsScreen extends StatelessWidget {
  final Promotion promotion;

  const PromotionDetailsScreen({
    super.key,
    required this.promotion,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.promotions),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: colorScheme.onPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                                                 Expanded(
                           child: Text(
                             promotion.name ?? '',
                             style: TextStyle(
                               fontSize: 24,
                               fontWeight: FontWeight.bold,
                               color: colorScheme.onPrimary,
                             ),
                           ),
                         ),
                      ],
                    ),
                    const SizedBox(height: 16),
                                         if (promotion.code != null && promotion.code!.isNotEmpty)
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                         decoration: BoxDecoration(
                           color: colorScheme.onPrimary.withOpacity(0.2),
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: Text(
                           '${l10n.code}: ${promotion.code!}',
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                             color: colorScheme.onPrimary,
                           ),
                         ),
                       ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
                             if (promotion.description != null && promotion.description!.isNotEmpty) ...[
                 Text(
                   l10n.description,
                   style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                     color: colorScheme.onSurface,
                   ),
                 ),
                 const SizedBox(height: 12),
                 Text(
                   promotion.description!,
                   style: TextStyle(
                     fontSize: 16,
                     height: 1.6,
                     color: colorScheme.onSurface,
                   ),
                 ),
                 const SizedBox(height: 24),
               ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.percent,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                                                 Text(
                           l10n.discount,
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                             color: colorScheme.onSurface,
                           ),
                         ),
                        const Spacer(),
                                                 Text(
                           '${promotion.discountPercentage?.toStringAsFixed(0) ?? '0'}%',
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             color: colorScheme.primary,
                           ),
                         ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                                                 Text(
                           l10n.validFrom,
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                             color: colorScheme.onSurface,
                           ),
                         ),
                        const Spacer(),
                        Text(
                          _formatDate(promotion.startDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                                                 Text(
                           l10n.validTo,
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                             color: colorScheme.onSurface,
                           ),
                         ),
                        const Spacer(),
                        Text(
                          _formatDate(promotion.endDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                                             child: Text(
                         l10n.useCodeMessage,
                         style: TextStyle(
                           fontSize: 14,
                           color: colorScheme.onPrimaryContainer,
                         ),
                       ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
} 
