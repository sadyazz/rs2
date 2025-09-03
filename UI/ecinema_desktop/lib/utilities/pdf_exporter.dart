import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/date_range_selector.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import '../models/ticket_sales.dart';
import '../models/revenue.dart';
import '../models/screening_attendance.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PdfExporter {
  static Future<String> exportToPDF(
    BuildContext context,
    List<TicketSales> ticketSales,
    List<Revenue> revenueData,
    List<ScreeningAttendance> attendanceData, {
    DateRangeType dateRangeType = DateRangeType.daily,
  }) async {
    final pdf = pw.Document();
    final l10n = AppLocalizations.of(context)!;

    DateTime? startDate;
    DateTime? endDate;
    
    if (ticketSales.isNotEmpty) {
      startDate = ticketSales.first.date;
      endDate = ticketSales.last.date;
    } else if (revenueData.isNotEmpty) {
      startDate = revenueData.first.date;
      endDate = revenueData.last.date;
    } else if (attendanceData.isNotEmpty) {
      startDate = attendanceData.first.startTime;
      endDate = attendanceData.last.startTime;
    }

    final dateRangeText = startDate != null && endDate != null
      ? '${startDate.toString().substring(0, 10)} - ${endDate.toString().substring(0, 10)}'
      : '';

    final pages = <pw.Widget>[
      pw.Header(
        level: 0,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              l10n.reports,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              dateRangeText,
              style: pw.TextStyle(
                fontSize: 14,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 20),
      
      pw.Header(level: 1, child: pw.Text(l10n.keyMetrics)),
      _buildPdfKeyMetrics(ticketSales, revenueData, attendanceData, l10n),
      pw.SizedBox(height: 20),
    ];

    if (ticketSales.isNotEmpty) {
      pages.add(pw.Header(level: 1, child: pw.Text(l10n.ticketSales)));
      pages.add(_buildTicketSalesChart(ticketSales, dateRangeType));
      pages.add(pw.SizedBox(height: 20));
    }

    if (revenueData.isNotEmpty) {
      pages.add(pw.Header(level: 1, child: pw.Text(l10n.revenue)));
      pages.add(_buildRevenueChart(revenueData, dateRangeType));
      pages.add(pw.SizedBox(height: 20));
    }

    if (attendanceData.isNotEmpty) {
      pages.add(pw.Header(level: 1, child: pw.Text(l10n.screeningAttendance)));
      pages.add(_buildAttendanceChart(attendanceData));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => pages,
      ),
    );

    final bytes = await pdf.save();
    await FileSaver.instance.saveFile(
      name: 'cinema_report_${DateTime.now().toIso8601String()}',
      bytes: bytes,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );

    return 'success';
  }

  static pw.Widget _buildPdfKeyMetrics(
    List<TicketSales> ticketSales,
    List<Revenue> revenueData,
    List<ScreeningAttendance> attendanceData,
    AppLocalizations l10n,
  ) {
    int totalTickets = ticketSales.fold(0, (sum, sale) => sum + sale.ticketCount);
    double totalRevenue = revenueData.fold(0, (sum, revenue) => sum + revenue.totalRevenue);
    double averageOccupancy = attendanceData.isNotEmpty
        ? attendanceData.fold(0.0, (sum, attendance) => sum + attendance.occupancyRate) / attendanceData.length
        : 0;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: [
        _buildPdfMetricBox(l10n.totalTicketsSold, totalTickets.toString()),
        _buildPdfMetricBox(l10n.totalRevenue, '\$${totalRevenue.toStringAsFixed(2)}'),
        _buildPdfMetricBox(l10n.averageOccupancy, '${averageOccupancy.toStringAsFixed(1)}%'),
      ],
    );
  }

  static pw.Widget _buildPdfMetricBox(String title, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(title),
        ],
      ),
    );
  }

  static pw.Widget _buildTicketSalesChart(List<TicketSales> data, DateRangeType dateRangeType) {
    if (data.isEmpty) return pw.Container();

    final spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final sale = entry.value;
      return pw.PointChartValue(index, sale.ticketCount.toDouble());
    }).toList();

    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final yInterval = ((maxY - minY) / 5).ceil().toDouble();
    final effectiveYInterval = yInterval <= 0 ? 1.0 : yInterval;

    final xLabels = data.map((sale) => 
      dateRangeType == DateRangeType.yearly
        ? '${sale.date.month}/${sale.date.year}'
        : '${sale.date.day}/${sale.date.month}'
    ).toList();

    return pw.Container(
      height: 400,
      child: pw.Chart(
        title: pw.Text('Ticket Sales'),
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis(
            List.generate(data.length, (i) => i.toDouble()),
            textStyle: pw.TextStyle(fontSize: 8),
            format: (value) => xLabels[value.toInt()],
          ),
          yAxis: pw.FixedAxis(List.generate(6, (i) => (minY + i * effectiveYInterval).toDouble())),
        ),
        datasets: [
          pw.LineDataSet(
            legend: 'Tickets',
            drawPoints: true,
            isCurved: true,
            lineWidth: 2,
            pointSize: 4,
            color: PdfColors.blue,
            data: spots,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildRevenueChart(List<Revenue> data, DateRangeType dateRangeType) {
    if (data.isEmpty) return pw.Container();

    final spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final revenue = entry.value;
      return pw.PointChartValue(index, revenue.totalRevenue);
    }).toList();

    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final yInterval = ((maxY - minY) / 5).ceil().toDouble();
    final effectiveYInterval = yInterval <= 0 ? 1.0 : yInterval;

    final xLabels = data.map((revenue) => 
      dateRangeType == DateRangeType.yearly
        ? '${revenue.date.month}/${revenue.date.year}'
        : '${revenue.date.day}/${revenue.date.month}'
    ).toList();

    return pw.Container(
      height: 400,
      child: pw.Chart(
        title: pw.Text('Revenue'),
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis(
            List.generate(data.length, (i) => i.toDouble()),
            textStyle: pw.TextStyle(fontSize: 8),
            format: (value) => xLabels[value.toInt()],
          ),
          yAxis: pw.FixedAxis(List.generate(6, (i) => (minY + i * effectiveYInterval).toDouble())),
        ),
        datasets: [
          pw.LineDataSet(
            legend: 'Revenue',
            drawPoints: true,
            isCurved: true,
            lineWidth: 2,
            pointSize: 4,
            color: PdfColors.green,
            data: spots,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAttendanceChart(List<ScreeningAttendance> data) {
    if (data.isEmpty) return pw.Container();

    final spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final attendance = entry.value;
      return pw.PointChartValue(index, attendance.occupancyRate);
    }).toList();

    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final yInterval = ((maxY - minY) / 5).ceil().toDouble();
    final effectiveYInterval = yInterval <= 0 ? 1.0 : yInterval;


    return pw.Container(
      height: 400,
      child: pw.Chart(
        title: pw.Text('Screening Attendance'),
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis(
            List.generate(data.length, (i) => i.toDouble()),
            format: (value) => data[value.toInt()].movieTitle,
          ),
          yAxis: pw.FixedAxis(
            List.generate(6, (i) => (minY + i * effectiveYInterval).toDouble()),
            format: (value) => '${value.toStringAsFixed(1)}%',
          ),
        ),
        datasets: [
          pw.BarDataSet(
            legend: 'Occupancy',
            width: 20,
            color: PdfColors.blue,
            data: spots,
          ),
        ],
      ),
    );
  }
}
