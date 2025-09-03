import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevenueCard extends StatelessWidget {
  final String title;
  final double totalRevenue;
  final int ticketCount;
  final double averageTicketPrice;

  const RevenueCard({
    super.key,
    required this.title,
    required this.totalRevenue,
    required this.ticketCount,
    required this.averageTicketPrice,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            _buildInfoRow(
              context,
              l10n.totalIncome,
              '\$${totalRevenue.toStringAsFixed(2)}',
              colorScheme.primary,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              l10n.totalSeats,
              ticketCount.toString(),
              colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Average Ticket Price',
              '\$${averageTicketPrice.toStringAsFixed(2)}',
              colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, Color color) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
