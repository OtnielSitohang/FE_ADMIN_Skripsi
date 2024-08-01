import 'package:flutter/material.dart';

// Model for BookingPerUser
class BookingPerUser {
  final String username;
  final int jumlahBooking;

  BookingPerUser({required this.username, required this.jumlahBooking});

  factory BookingPerUser.fromJson(Map<String, dynamic> json) {
    return BookingPerUser(
      username: json['username'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}

// Example Data (replace with actual API call in production)
final List<BookingPerUser> exampleBookingsPerUser = [
  BookingPerUser(username: "admin1", jumlahBooking: 5),
  BookingPerUser(username: "customer1", jumlahBooking: 9),
];

class BookingsPerUserCard extends StatelessWidget {
  final List<BookingPerUser> bookingsPerUser;

  const BookingsPerUserCard({Key? key, required this.bookingsPerUser})
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
                'Statistik Booking Berdasarkan Jenis Lapangan',
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
            for (var booking in bookingsPerUser) ...[
              ListTile(
                leading: Icon(Icons.person),
                title: Text(booking.username),
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
