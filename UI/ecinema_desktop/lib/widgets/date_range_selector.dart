import 'package:flutter/material.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';

class DateRangeSelector extends StatefulWidget {
  final Function(DateTime, DateTime, DateRangeType) onDateRangeChanged;

  const DateRangeSelector({
    super.key,
    required this.onDateRangeChanged,
  });

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

enum DateRangeType {
  daily,
  weekly,
  monthly,
  yearly,
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTimeRange? _selectedDateRange;
  DateRangeType _selectedType = DateRangeType.weekly;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDateRange(DateRangeType.weekly);
    });
  }

  void _setDateRange(DateRangeType type) {
    final now = DateTime(2025, DateTime.now().month, DateTime.now().day);
    DateTimeRange range;

    switch (type) {
      case DateRangeType.daily:
        range = DateTimeRange(
          start: now,
          end: now,
        );
        break;
      case DateRangeType.weekly:
        range = DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
        break;
      case DateRangeType.monthly:
        range = DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
        break;
      case DateRangeType.yearly:
        range = DateTimeRange(
          start: now.subtract(const Duration(days: 365)),
          end: now,
        );
        break;
    }

    setState(() {
      _selectedType = type;
      _selectedDateRange = range;
    });
    widget.onDateRangeChanged(range.start, range.end, type);
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dateRange,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.daily),
                        selected: _selectedType == DateRangeType.daily,
                        onSelected: (selected) {
                          if (selected) _setDateRange(DateRangeType.daily);
                        },
                      ),
                      ChoiceChip(
                        label: Text(l10n.weekly),
                        selected: _selectedType == DateRangeType.weekly,
                        onSelected: (selected) {
                          if (selected) _setDateRange(DateRangeType.weekly);
                        },
                      ),
                      ChoiceChip(
                        label: Text(l10n.monthly),
                        selected: _selectedType == DateRangeType.monthly,
                        onSelected: (selected) {
                          if (selected) _setDateRange(DateRangeType.monthly);
                        },
                      ),
                      ChoiceChip(
                        label: Text(l10n.yearly),
                        selected: _selectedType == DateRangeType.yearly,
                        onSelected: (selected) {
                          if (selected) _setDateRange(DateRangeType.yearly);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                if (_selectedDateRange != null)
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.calendar_today,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
