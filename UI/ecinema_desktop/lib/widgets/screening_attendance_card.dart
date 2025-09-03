import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreeningAttendanceCard extends StatelessWidget {
  final String movieTitle;
  final int totalSeats;
  final int soldSeats;
  final double attendancePercentage;

  const ScreeningAttendanceCard({
    super.key,
    required this.movieTitle,
    required this.totalSeats,
    required this.soldSeats,
    required this.attendancePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: attendancePercentage / 100,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(colorScheme, attendancePercentage),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${attendancePercentage.toStringAsFixed(1)}%',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getProgressColor(colorScheme, attendancePercentage),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$soldSeats/${totalSeats} ${AppLocalizations.of(context)!.seats.toLowerCase()}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(ColorScheme colorScheme, double percentage) {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 50) {
      return colorScheme.primary;
    } else if (percentage >= 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
