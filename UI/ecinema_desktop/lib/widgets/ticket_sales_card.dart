import 'package:flutter/material.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';

class TicketSalesCard extends StatelessWidget {
  final int totalTickets;
  final int soldTickets;
  final double totalRevenue;

  const TicketSalesCard({
    super.key,
    required this.totalTickets,
    required this.soldTickets,
    required this.totalRevenue,
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
              l10n.ticketSales,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  totalTickets.toString(),
                  l10n.totalSeats,
                  colorScheme.primary,
                ),
                _buildStatColumn(
                  context,
                  soldTickets.toString(),
                  l10n.reservedSeats,
                  colorScheme.secondary,
                ),
                _buildStatColumn(
                  context,
                  (totalTickets - soldTickets).toString(),
                  l10n.availableSeats,
                  colorScheme.tertiary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${l10n.totalIncome}: ',
                  style: textTheme.titleMedium,
                ),
                Text(
                  '\$${totalRevenue.toStringAsFixed(2)}',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label, Color color) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              value,
              style: textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
