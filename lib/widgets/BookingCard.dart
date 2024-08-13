import 'package:flutter/material.dart';
import 'package:frontadmin/global/url.dart';
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
      margin: EdgeInsets.all(12.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sports_soccer, color: Colors.blue, size: 30.0),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Nama Lapangan: ${booking.nama_lapangan}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.category, color: Colors.green, size: 30.0),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Jenis Lapangan: ${booking.jenis_lapangan}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, color: Colors.orange, size: 30.0),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Booking oleh: ${booking.nama_pengguna}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.purple, size: 30.0),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Tanggal Booking: ${_formatDateTime(booking.tanggalBooking)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.red, size: 30.0),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Tanggal Penggunaan: ${_formatDateTime(booking.tanggalPenggunaan)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.cyan, size: 30.0),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Sesi: ${booking.sesi}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showBuktiBayarDialog(context, booking);
                  },
                  icon: Icon(Icons.visibility),
                  label: Text("Lihat Bukti Bayar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: booking.statusKonfirmasi == '0'
                      ? () {
                          _confirmBooking(context, booking.id);
                        }
                      : null,
                  icon: Icon(Icons.check),
                  label: Text("Konfirmasi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
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
    try {
      final imageData = base64Decode(booking.buktiPembayaran);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bukti Pembayaran oleh ${booking.nama_pengguna}"),
            content: Container(
              width: double.maxFinite,
              child: Image.memory(
                imageData,
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menampilkan bukti bayar: $e')),
      );
    }
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
      final url = '$baseUrlApi/bookings/confirm/$bookingId';

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
