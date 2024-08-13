import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontadmin/models/UserProvider.dart';
import 'package:frontadmin/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:frontadmin/services/Booking.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final BookingService _availabilityService = BookingService();
  final ImagePicker _picker = ImagePicker();

  String? _selectedJenisLapangan;

  List<Map<String, String>> _jenisLapanganOptions = [
    {'id': '1', 'name': 'Keramik'},
    {'id': '2', 'name': 'Karpet'},
    {'id': '3', 'name': 'Vinyl'},
  ];
  String? _selectedSesi;
  DateTime _selectedDate = DateTime.now();
  DateTime _maxDate = DateTime.now().add(Duration(days: 7));
  List<Map<String, dynamic>> _availableFields = [];
  String? _selectedLapanganId;
  String? _paymentProofBase64;
  int? _selectedPenggunaId;
  String? _selectedFieldPrice;

  List<String> _sesiOptions = [
    '08-10',
    '10-12',
    '12-14',
    '14-16',
    '16-18',
    '18-20',
    '20-22',
    '22-24',
  ];

  List<Map<String, dynamic>> _penggunaOptions = []; // List to store users

  @override
  void initState() {
    super.initState();
    _fetchPengguna();
  }

  Future<void> _fetchPengguna() async {
    try {
      final users = await _availabilityService.fetchCustomers();
      setState(() {
        _penggunaOptions = users;
      });
    } catch (e) {
      print('Error fetching pengguna: $e');
    }
  }

  void _searchAvailability() async {
    if (_selectedJenisLapangan == null ||
        _selectedSesi == null ||
        _selectedPenggunaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all required fields')),
      );
      return;
    }

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final results = await _availabilityService.checkAvailability(
        jenisLapanganId: _selectedJenisLapangan!,
        tanggalPenggunaan: formattedDate,
        sesi: _selectedSesi!,
      );

      setState(() {
        _availableFields = results;
        _selectedLapanganId = null; // Reset the selected lapangan ID
      });
    } catch (e) {
      print('Error checking availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check availability')),
      );
    }
  }

  void _bookField() async {
    if (_selectedLapanganId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a field to book')),
      );
      return;
    }

    if (_paymentProofBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload payment proof')),
      );
      return;
    }

    if (!_sesiOptions.contains(_selectedSesi)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid sesi selected')),
      );
      return;
    }

    try {
      final penggunaId = _selectedPenggunaId!;
      final harga = _availableFields
          .firstWhere(
              (field) => field['id'].toString() == _selectedLapanganId)['harga']
          .toString(); // Convert to String if needed

      print(
          'Booking request: pengguna_id=$_selectedPenggunaId, lapangan_id=$_selectedLapanganId, jenis_lapangan_id=$_selectedJenisLapangan, tanggal_booking=${DateFormat('yyyy-MM-dd').format(DateTime.now())}, tanggal_penggunaan=${DateFormat('yyyy-MM-dd').format(_selectedDate)}, sesi=$_selectedSesi, foto_base64=$_paymentProofBase64, harga=$harga');

      await BookingService.bookField(
        pengguna_id: penggunaId,
        lapangan_id: int.parse(_selectedLapanganId!), // Convert to int
        jenis_lapangan_id: int.parse(_selectedJenisLapangan!),
        tanggal_booking: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        tanggal_penggunaan: DateFormat('yyyy-MM-dd').format(_selectedDate),
        sesi: _selectedSesi!,
        foto_base64: _paymentProofBase64!,
        harga: double.parse(harga),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful!')),
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final User? currentUser = userProvider.user;

      if (currentUser != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/drawer',
          (Route<dynamic> route) => false,
          arguments: currentUser,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not available')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create booking: $e')),
      );
    }
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64String = base64Encode(bytes);
      setState(() {
        _paymentProofBase64 = base64String;
      });
    }
  }

  Future<void> _selectImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64String = base64Encode(bytes);
      setState(() {
        _paymentProofBase64 = base64String;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Payment Proof'),
          content: Text('Choose the source of the image'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectImage();
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectImageFromCamera();
              },
              child: Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchPengguna, // Refresh pengguna list
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 24),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedPenggunaId
                          ?.toString(), // Ensure this is a String
                      hint: Text('Select User'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPenggunaId =
                              newValue != null ? int.parse(newValue) : null;
                        });
                      },
                      items: _penggunaOptions.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['id'].toString(), // Convert ID to String
                          child: Text(item['username']),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.sports_soccer, size: 24),
                  SizedBox(width: 8),
                  Expanded(
                      child: DropdownButton<String>(
                    value: _selectedJenisLapangan,
                    hint: Text('Pilih Jenis Lapangan'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedJenisLapangan = newValue;
                      });
                    },
                    items: _jenisLapanganOptions.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id']!, // Ensure ID is not null
                        child: Text(item['name']!),
                      );
                    }).toList(),
                  )),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 24),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: _maxDate,
                        );

                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child:
                          Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedSesi,
                onChanged: (String? value) {
                  setState(() {
                    _selectedSesi = value;
                  });
                },
                items:
                    _sesiOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _searchAvailability,
                child: Text('Cari'),
              ),
              SizedBox(height: 16),
              _availableFields.isNotEmpty
                  ? Column(
                      children: [
                        for (var field in _availableFields)
                          ListTile(
                            title: Text(field['nama_lapangan']),
                            subtitle: Text('Harga: ${field['harga']}'),
                            leading: Radio<String>(
                              value: field['id'].toString(),
                              groupValue: _selectedLapanganId,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedLapanganId = value;
                                });
                              },
                            ),
                          ),
                      ],
                    )
                  : Center(
                      child: Text('No fields available'),
                    ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.upload_file, size: 24),
                  SizedBox(width: 8),
                  Text('Upload Payment Proof:'),
                ],
              ),
              ElevatedButton(
                onPressed: _showImageSourceDialog,
                child: Text('Choose Image'),
              ),
              SizedBox(height: 16),
              _paymentProofBase64 != null
                  ? Image.memory(base64Decode(_paymentProofBase64!))
                  : Text('No image selected'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _bookField,
                child: Text('Book Field'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
