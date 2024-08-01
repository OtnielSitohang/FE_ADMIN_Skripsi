import 'package:flutter/material.dart';

// Model for BookingPerJenisLapangan
class BookingPerJenisLapangan {
  final String jenisLapangan;
  final int jumlahBooking;

  BookingPerJenisLapangan(
      {required this.jenisLapangan, required this.jumlahBooking});

  factory BookingPerJenisLapangan.fromJson(Map<String, dynamic> json) {
    return BookingPerJenisLapangan(
      jenisLapangan: json['jenis_lapangan'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}

// Example Data (replace with actual API call in production)
final List<BookingPerJenisLapangan> exampleBookingsPerJenisLapangan = [
  BookingPerJenisLapangan(jenisLapangan: "Karpet", jumlahBooking: 3),
  BookingPerJenisLapangan(jenisLapangan: "Keramik", jumlahBooking: 10),
  BookingPerJenisLapangan(jenisLapangan: "Vinly", jumlahBooking: 1),
];

class BookingsPerJenisLapanganCard extends StatelessWidget {
  final List<BookingPerJenisLapangan> bookingsPerJenisLapangan;

  const BookingsPerJenisLapanganCard(
      {Key? key, required this.bookingsPerJenisLapangan})
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
            for (var booking in bookingsPerJenisLapangan) ...[
              ListTile(
                leading: _getIconForJenisLapangan(booking.jenisLapangan),
                title: Text(booking.jenisLapangan),
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

  Icon _getIconForJenisLapangan(String jenisLapangan) {
    switch (jenisLapangan) {
      case 'Karpet':
        return Icon(Icons.add_box, color: Colors.green);
      case 'Keramik':
        return Icon(Icons.hardware, color: Colors.orange);
      case 'Vinly':
        return Icon(Icons.settings, color: Colors.blue);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
  }
}
