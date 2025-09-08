class TicketSales {
  final DateTime date;
  final int ticketCount;
  final double totalRevenue;

  TicketSales({
    required this.date,
    required this.ticketCount,
    required this.totalRevenue,
  });

  factory TicketSales.fromJson(Map<String, dynamic> json) {
    return TicketSales(
      date: DateTime.parse(json['date']),
      ticketCount: json['ticketCount'],
      totalRevenue: json['totalRevenue'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'ticketCount': ticketCount,
      'totalRevenue': totalRevenue,
    };
  }
}
