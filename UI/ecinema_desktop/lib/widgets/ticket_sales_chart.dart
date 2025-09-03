import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/ticket_sales.dart';
import '../widgets/date_range_selector.dart';

class TicketSalesChart extends StatelessWidget {
  final List<TicketSales> ticketSales;
  final DateRangeType dateRangeType;

  const TicketSalesChart({
    super.key,
    required this.ticketSales,
    required this.dateRangeType,
  });

  List<TicketSales> _aggregateData(List<TicketSales> data) {
    if (data.isEmpty) return [];

    switch (dateRangeType) {
      case DateRangeType.daily:
      case DateRangeType.weekly:
      case DateRangeType.monthly:
        return data;
      case DateRangeType.yearly:
        return _aggregateByMonth(data);
    }
  }

  List<TicketSales> _aggregateByMonth(List<TicketSales> data) {
    final Map<DateTime, TicketSales> groupedData = {};
    
    for (var item in data) {
      final groupDate = DateTime(item.date.year, item.date.month, 1);
      if (!groupedData.containsKey(groupDate)) {
        groupedData[groupDate] = TicketSales(
          date: groupDate,
          ticketCount: item.ticketCount,
          totalRevenue: item.totalRevenue,
        );
      } else {
        final existing = groupedData[groupDate]!;
        groupedData[groupDate] = TicketSales(
          date: groupDate,
          ticketCount: existing.ticketCount + item.ticketCount,
          totalRevenue: existing.totalRevenue + item.totalRevenue,
        );
      }
    }

    return groupedData.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (ticketSales.isEmpty) {
      return Center(
        child: Text(l10n.noDataAvailable),
      );
    }

    final aggregatedData = _aggregateData(ticketSales);
    if (aggregatedData.isEmpty) {
      return Center(
        child: Text(l10n.noDataAvailable),
      );
    }

    final List<FlSpot> spots = aggregatedData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final sale = entry.value;
      return FlSpot(index, sale.ticketCount.toDouble());
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
                  if (value.toInt() >= aggregatedData.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: (dateRangeType == DateRangeType.yearly || dateRangeType == DateRangeType.monthly) ? 16.0 : 8.0,
                    ),
                    child: Transform.rotate(
                      angle: (dateRangeType == DateRangeType.yearly || dateRangeType == DateRangeType.monthly) ? -0.5 : 0,
                      child: Text(
                        dateRangeType == DateRangeType.yearly
                          ? '${aggregatedData[value.toInt()].date.month}/${aggregatedData[value.toInt()].date.year}'
                          : '${aggregatedData[value.toInt()].date.day}/${aggregatedData[value.toInt()].date.month}',
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
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
                reservedSize: 42,
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
          maxX: (aggregatedData.length - 1).toDouble(),
          minY: minY - yInterval,
          maxY: maxY + yInterval,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withOpacity(0.1),
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
                  
                  final sale = aggregatedData[index];
                  final date = sale.date;
                  final tickets = sale.ticketCount;
                  return LineTooltipItem(
                    '${date.day}/${date.month}/${date.year}\n',
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: '$tickets ${l10n.totalTicketsSold}',
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
