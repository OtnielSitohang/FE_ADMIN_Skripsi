import 'package:flutter/material.dart';
import 'package:frontadmin/models/Booking.dart';
import 'package:frontadmin/services/Booking.dart';
import 'package:frontadmin/widgets/BookingCard.dart';
import 'package:intl/intl.dart'; // Import untuk DateFormat

class KonfirmasiLapanganPage extends StatefulWidget {
  @override
  _KonfirmasiLapanganPageState createState() => _KonfirmasiLapanganPageState();
}

class _KonfirmasiLapanganPageState extends State<KonfirmasiLapanganPage> {
  late Future<List<Booking>> futureBookings;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      futureBookings = fetchBookings().then((bookings) {
        // Mengurutkan data berdasarkan status_konfirmasi dan tanggal_penggunaan
        bookings.sort((a, b) {
          // Urutkan berdasarkan status_konfirmasi (0 di atas 1)
          if (a.statusKonfirmasi != b.statusKonfirmasi) {
            return a.statusKonfirmasi == 0 ? -1 : 1;
          }
          // Jika status_konfirmasi sama, urutkan berdasarkan tanggal_penggunaan
          DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.tanggalPenggunaan);
          DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.tanggalPenggunaan);
          return dateA.compareTo(dateB);
        });
        return bookings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchData, // Menambahkan tombol refresh
          ),
        ],
      ),
      body: FutureBuilder<List<Booking>>(
        future: futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return BookingCard(
                  booking: snapshot.data![index],
                  onBookingChanged: fetchData,
                );
              },
            );
          }
        },
      ),
    );
  }
}
