import 'package:flutter/material.dart';
import 'package:frontadmin/services/LapanganService.dart';

class TambahLapanganPage extends StatefulWidget {
  @override
  _TambahLapanganPageState createState() => _TambahLapanganPageState();
}

class _TambahLapanganPageState extends State<TambahLapanganPage> {
  int _selectedJenisLapangan = 1; // Default jenis lapangan_id
  String _namaLapangan = '';
  int _harga = 100000; // Default harga

  // Metode untuk mengubah nilai jenis lapangan yang dipilih
  void _onJenisLapanganChanged(int? newValue) {
    setState(() {
      _selectedJenisLapangan =
          newValue ?? 1; // Jika newValue null, berikan nilai default 1
      // Set harga berdasarkan jenis lapangan_id yang dipilih
      if (_selectedJenisLapangan == 1) {
        _harga = 100000;
      } else if (_selectedJenisLapangan == 2) {
        _harga = 150000;
      } else if (_selectedJenisLapangan == 3) {
        _harga = 120000;
      }
    });
  }

  void _saveLapangan() async {
    if (_namaLapangan.isEmpty) {
      _showValidationDialog('Nama lapangan harus diisi');
      return;
    }

    String jenisLapanganText = '';
    switch (_selectedJenisLapangan) {
      case 1:
        jenisLapanganText = 'Keramik';
        break;
      case 2:
        jenisLapanganText = 'Karpet';
        break;
      case 3:
        jenisLapanganText = 'Vinly';
        break;
      default:
        jenisLapanganText = 'Unknown';
    }

    bool confirm = await _showConfirmDialog(jenisLapanganText, _namaLapangan);
    if (confirm) {
      try {
        String message = await LapanganService.createLapangan(
            _selectedJenisLapangan, _namaLapangan, _harga);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Info'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  _resetForm(); // Panggil metode reset
                  _namaLapangan = '';
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<bool> _showConfirmDialog(
      String jenisLapangan, String namaLapangan) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Konfirmasi'),
            content: Text(
                'Apakah Anda yakin ingin menambah lapangan $jenisLapangan dengan nama "$namaLapangan"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, true); // Return true to indicate confirmation
                },
                child: Text('Ya'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, false); // Return false to indicate cancellation
                },
                child: Text('Batal'),
              ),
            ],
          ),
        ) ??
        false; // Ensure a boolean value is returned even if showDialog returns null
  }

  void _showValidationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Peringatan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog peringatan
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedJenisLapangan = 1; // Atur kembali ke jenis lapangan default
      _namaLapangan = ''; // Kosongkan nama lapangan
      _harga = 100000; // Atur harga kembali ke default
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Lapangan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              value: _selectedJenisLapangan,
              onChanged: _onJenisLapanganChanged,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Keramik'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Karpet'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Vinly'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Jenis Lapangan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _namaLapangan = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nama Lapangan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
                'Harga: $_harga'), // Menampilkan harga berdasarkan jenis lapangan_id yang dipilih
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveLapangan,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
