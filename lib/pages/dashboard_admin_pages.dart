import 'package:flutter/material.dart';
import 'package:frontadmin/components/dashboard/bookingsbystatus.dart';
import 'package:frontadmin/components/dashboard/bookingspermonth.dart';
import 'package:frontadmin/components/dashboard/bookingsperuser.dart';
import 'package:frontadmin/components/dashboard/newuserspermonth.dart';
import 'package:frontadmin/components/dashboard/revenuepermonth.dart';

// Import cards
import '../components/dashboard/bookingsperjenislapangan.dart';

class DashboardAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statisctic Admin'),
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
    home: DashboardAdminPage(),
  ));
}
