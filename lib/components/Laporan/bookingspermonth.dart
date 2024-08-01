import 'package:flutter/material.dart';

// Model for BookingPerMonth
class BookingPerMonth {
  final String bulan;
  final int jumlahBooking;

  BookingPerMonth({required this.bulan, required this.jumlahBooking});

  factory BookingPerMonth.fromJson(Map<String, dynamic> json) {
    return BookingPerMonth(
      bulan: json['bulan'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}

// Example Data (replace with actual API call in production)
final List<BookingPerMonth> exampleBookingsPerMonth = [
  BookingPerMonth(bulan: "2024-07", jumlahBooking: 12),
  BookingPerMonth(bulan: "2024-08", jumlahBooking: 1),
  BookingPerMonth(bulan: "2028-07", jumlahBooking: 1),
];

class BookingsPerMonthCard extends StatelessWidget {
  final List<BookingPerMonth> bookingsPerMonth;

  const BookingsPerMonthCard({Key? key, required this.bookingsPerMonth})
      : super(key: key);

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
                'Statistik Booking Per Bulan',
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
            for (var booking in bookingsPerMonth) ...[
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(booking.bulan),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book_online),
                    SizedBox(width: 8),
                    Text('${booking.jumlahBooking}'),
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
