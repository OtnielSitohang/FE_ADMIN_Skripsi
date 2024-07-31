import 'package:flutter/material.dart';

// Model for RevenuePerMonth
class RevenuePerMonth {
  final String bulan;
  final int totalPendapatan;

  RevenuePerMonth({required this.bulan, required this.totalPendapatan});

  factory RevenuePerMonth.fromJson(Map<String, dynamic> json) {
    return RevenuePerMonth(
      bulan: json['bulan'],
      totalPendapatan: json['total_pendapatan'],
    );
  }
}

// Example Data (replace with actual API call in production)
final List<RevenuePerMonth> exampleRevenuePerMonth = [
  RevenuePerMonth(bulan: "2024-07", totalPendapatan: 620000),
  RevenuePerMonth(bulan: "2024-08", totalPendapatan: 100000),
  RevenuePerMonth(bulan: "2028-07", totalPendapatan: 0),
];

class RevenuePerMonthCard extends StatelessWidget {
  final List<RevenuePerMonth> revenuePerMonth;

  const RevenuePerMonthCard({Key? key, required this.revenuePerMonth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Pendapatan Per Bulan',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            for (var revenue in revenuePerMonth) ...[
              ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text(revenue.bulan),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_money),
                    SizedBox(width: 8),
                    Text('${revenue.totalPendapatan}'),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
