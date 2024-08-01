import 'package:flutter/material.dart';

// Model for BookingByStatus
class BookingByStatus {
  final int statusKonfirmasi;
  final int jumlahBooking;

  BookingByStatus(
      {required this.statusKonfirmasi, required this.jumlahBooking});

  factory BookingByStatus.fromJson(Map<String, dynamic> json) {
    return BookingByStatus(
      statusKonfirmasi: json['status_konfirmasi'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}

// Example Data (replace with actual API call in production)
final List<BookingByStatus> exampleBookingsByStatus = [
  BookingByStatus(statusKonfirmasi: 0, jumlahBooking: 1),
  BookingByStatus(statusKonfirmasi: 1, jumlahBooking: 13),
];

class BookingsByStatusCard extends StatelessWidget {
  final List<BookingByStatus> bookingsByStatus;

  const BookingsByStatusCard({Key? key, required this.bookingsByStatus})
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
                'Booking Berdasarkan Status',
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
            for (var booking in bookingsByStatus) ...[
              ListTile(
                leading: Icon(
                    booking.statusKonfirmasi == 1 ? Icons.check : Icons.close),
                title: Text(booking.statusKonfirmasi == 1
                    ? 'Terverifikasi'
                    : 'Belum Terverifikasi'),
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
