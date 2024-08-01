import 'package:flutter/material.dart';
import 'package:frontadmin/components/Laporan/bookingsbystatus.dart';
import 'package:frontadmin/components/Laporan/bookingspermonth.dart';
import 'package:frontadmin/components/Laporan/bookingsperuser.dart';
import 'package:frontadmin/components/Laporan/newuserspermonth.dart';
import 'package:frontadmin/components/Laporan/revenuepermonth.dart';

// Import cards
import '../components/Laporan/bookingsperjenislapangan.dart';

class LaporanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Statistic Lapangan'),
      ),
      body: ListView(
        children: [
          BookingsPerJenisLapanganCard(
              bookingsPerJenisLapangan: exampleBookingsPerJenisLapangan),
          BookingsPerMonthCard(bookingsPerMonth: exampleBookingsPerMonth),
          NewUsersPerMonthCard(newUsersPerMonth: exampleNewUsersPerMonth),
          RevenuePerMonthCard(revenuePerMonth: exampleRevenuePerMonth),
          BookingsByStatusCard(bookingsByStatus: exampleBookingsByStatus),
          BookingsPerUserCard(bookingsPerUser: exampleBookingsPerUser),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LaporanPage(),
  ));
}
