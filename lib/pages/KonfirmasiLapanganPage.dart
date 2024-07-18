import 'package:flutter/material.dart';
import 'package:frontadmin/models/Booking.dart';
import 'package:frontadmin/services/Booking.dart';
import 'package:frontadmin/widgets/BookingCard.dart';

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
      futureBookings = fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
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
