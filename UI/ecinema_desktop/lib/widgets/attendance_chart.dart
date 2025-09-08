import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import '../models/screening_attendance.dart';

class AttendanceChart extends StatelessWidget {
  final List<ScreeningAttendance> attendanceData;

  const AttendanceChart({
    super.key,
    required this.attendanceData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (attendanceData.isEmpty) {
      return Center(
        child: Text(l10n.noDataAvailable),
      );
    }

    final List<BarChartGroupData> barGroups = attendanceData.asMap().entries.map((entry) {
      final data = entry.value;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: data.occupancyRate,
            color: colorScheme.tertiary,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 21 / 9,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
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
                reservedSize: 60,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= attendanceData.length) {
                    return const SizedBox.shrink();
                  }
                  final data = attendanceData[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        '${data.movieTitle}\n${data.hallName}',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
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
          barGroups: barGroups,
          maxY: 100,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: colorScheme.surface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = attendanceData[group.x];
                return BarTooltipItem(
                  '${data.movieTitle}\n${data.hallName}\n',
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                      text: '${data.reservedSeats} / ${data.totalSeats} ${l10n.seats}\n',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: colorScheme.onSurface,
                          ),
                    ),
                    TextSpan(
                      text: '${data.occupancyRate.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: colorScheme.onSurface,
                          ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
