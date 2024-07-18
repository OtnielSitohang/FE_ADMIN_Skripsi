import 'package:flutter/material.dart';
import 'package:frontadmin/models/Booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onBookingChanged;

  BookingCard({required this.booking, required this.onBookingChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama Lapangan: ${booking.nama_lapangan}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Jenis Lapangan: ${booking.jenis_lapangan}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              "Booking oleh: ${booking.nama_pengguna}",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "Tanggal Booking: ${_formatDateTime(booking.tanggalBooking)}",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "Tanggal Penggunaan: ${_formatDateTime(booking.tanggalPenggunaan)}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              "Sesi: ${booking.sesi}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showBuktiBayarDialog(context, booking);
                    onBookingChanged();
                  },
                  child: Text("Lihat Bukti Bayar"),
                ),
                ElevatedButton(
                  onPressed: booking.statusKonfirmasi == '0'
                      ? () {
                          _confirmBooking(context, booking.id);
                          onBookingChanged();
                        }
                      : null,
                  child: Text("Konfirmasi"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy, HH:mm').format(dateTime);
    return formattedDate;
  }

  void _showBuktiBayarDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bukti Pembayaran oleh ${booking.nama_pengguna}"),
          content: Container(
            child: Image.memory(
              base64Decode(booking.buktiPembayaran),
              fit: BoxFit.contain,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmBooking(BuildContext context, int bookingId) async {
    // Tampilkan dialog konfirmasi
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin mengkonfirmasi booking ini?"),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Tutup dialog dengan nilai false
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Tutup dialog dengan nilai true
              },
            ),
          ],
        );
      },
    );

    // Jika pengguna mengkonfirmasi, lanjutkan dengan request HTTP
    if (confirm == true) {
      final url = 'http://localhost:3000/auth/bookings/confirm/$bookingId';

      try {
        final response = await http.put(Uri.parse(url));

        if (response.statusCode == 200) {
          // Successfully confirmed booking
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking dikonfirmasi!')),
          );
          // Optionally, update the UI or fetch the updated booking list
        } else {
          // Failed to confirm booking
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengkonfirmasi booking.')),
          );
        }
      } catch (e) {
        // Error during the request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error mengkonfirmasi booking.')),
        );
      }
    }
  }
}
