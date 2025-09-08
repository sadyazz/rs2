import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import '../models/revenue.dart';
import '../widgets/date_range_selector.dart';

class RevenueChart extends StatelessWidget {
  final List<Revenue> revenueData;
  final DateRangeType dateRangeType;

  const RevenueChart({
    super.key,
    required this.revenueData,
    required this.dateRangeType,
  });

  List<Revenue> _aggregateData(List<Revenue> data) {
    if (data.isEmpty) return [];

    switch (dateRangeType) {
      case DateRangeType.daily:
      case DateRangeType.weekly:
        return data;
      case DateRangeType.monthly:
        return data;
      case DateRangeType.yearly:
        return _aggregateByMonth(data);
    }
  }


  List<Revenue> _aggregateByMonth(List<Revenue> data) {
    final Map<DateTime, Revenue> groupedData = {};
    for (var item in data) {
      final groupDate = DateTime(item.date.year, item.date.month, 1);
      if (!groupedData.containsKey(groupDate)) {
        groupedData[groupDate] = Revenue(
          date: groupDate,
          totalRevenue: item.totalRevenue,
          reservationCount: item.reservationCount,
          averageTicketPrice: item.averageTicketPrice,
          movieTitle: item.movieTitle,
          hallName: item.hallName,
        );
      } else {
        final existing = groupedData[groupDate]!;
        groupedData[groupDate] = Revenue(
          date: groupDate,
          totalRevenue: existing.totalRevenue + item.totalRevenue,
          reservationCount: existing.reservationCount + item.reservationCount,
          averageTicketPrice: (existing.totalRevenue + item.totalRevenue) / 
                            (existing.reservationCount + item.reservationCount > 0 ? 
                             existing.reservationCount + item.reservationCount : 1),
          movieTitle: item.movieTitle,
          hallName: item.hallName,
        );
      }
    }

    return groupedData.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (revenueData.isEmpty) {
      return Center(
        child: Text(l10n.noDataAvailable),
      );
    }

    final aggregatedData = _aggregateData(revenueData);
    if (aggregatedData.isEmpty) {
      return Center(
        child: Text(l10n.noDataAvailable),
      );
    }
    
    final List<FlSpot> spots = aggregatedData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final revenue = entry.value;
      return FlSpot(index, revenue.totalRevenue.toDouble());
    }).toList();
    

    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final yInterval = ((maxY - minY) / 5).ceilToDouble();
    final effectiveYInterval = yInterval <= 0 ? 1.0 : yInterval;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: effectiveYInterval,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: colorScheme.outlineVariant,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: colorScheme.outlineVariant,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: (dateRangeType == DateRangeType.yearly || dateRangeType == DateRangeType.monthly) ? 50 : 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= aggregatedData.length) {
                    return const SizedBox.shrink();
                  }
                  final date = aggregatedData[index].date;
                  
                  String dateText;
                  
                  if (dateRangeType == DateRangeType.yearly) {
                    dateText = '${date.month}/${date.year}';
                  } else {
                    dateText = '${date.day}/${date.month}';
                  }
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      top: (dateRangeType == DateRangeType.yearly || dateRangeType == DateRangeType.monthly) ? 16.0 : 8.0,
                    ),
                    child: Transform.rotate(
                      angle: (dateRangeType == DateRangeType.yearly || dateRangeType == DateRangeType.monthly) ? -0.5 : 0,
                      child: Text(
                        dateText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: effectiveYInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
                reservedSize: 60,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: colorScheme.outline, width: 1),
              left: BorderSide(color: colorScheme.outline, width: 1),
              right: BorderSide(color: colorScheme.outline, width: 1),
              top: BorderSide(color: colorScheme.outline, width: 1),
            ),
          ),
          minX: 0,
          maxX: spots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b),
          minY: minY - yInterval,
          maxY: maxY + yInterval,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: colorScheme.surface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  if (index >= aggregatedData.length) return null;
                  
                  final revenue = aggregatedData[index];
                  final date = revenue.date;
                  final movieTitle = revenue.movieTitle;
                  final hallName = revenue.hallName;

                  String tooltipText = '${date.day}/${date.month}/${date.year}\n';
                  if (movieTitle != null) {
                    tooltipText += '$movieTitle\n';
                  }
                  if (hallName != null) {
                    tooltipText += '$hallName\n';
                  }

                  return LineTooltipItem(
                    tooltipText,
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: '\$${revenue.totalRevenue.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: colorScheme.onSurface,
                            ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
