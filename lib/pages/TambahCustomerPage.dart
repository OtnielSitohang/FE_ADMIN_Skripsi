import 'package:flutter/material.dart';
import 'package:frontadmin/models/user.dart'; // Sesuaikan dengan lokasi model User Anda
import '../services/pengguna_service.dart'; // Sesuaikan dengan lokasi service Anda
import 'drawer_page.dart'; // Sesuaikan dengan lokasi DrawerPage Anda

class TambahCustomerPage extends StatefulWidget {
  final User user;

  TambahCustomerPage({required this.user});

  @override
  _TambahCustomerPageState createState() => _TambahCustomerPageState();
}

class _TambahCustomerPageState extends State<TambahCustomerPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tempatTinggalController =
      TextEditingController();
  bool _obscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _tambahPengguna() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();
      final String namaLengkap = _namaLengkapController.text.trim();
      final String tanggalLahir = _tanggalLahirController.text.trim();
      final String email = _emailController.text.trim();
      final String tempatTinggal = _tempatTinggalController.text.trim();
      final String role = 'customer';

      try {
        await PenggunaService.tambahPengguna(
          username: username,
          password: password,
          namaLengkap: namaLengkap,
          tanggalLahir: tanggalLahir,
          email: email,
          tempatTinggal: tempatTinggal,
          role: role,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User added successfully'),
            duration: Duration(seconds: 3),
          ),
        );

        await Future.delayed(Duration(seconds: 3));

        Navigator.pushReplacementNamed(context, '/drawer',
            arguments: widget.user);
      } catch (e) {
        print('Error: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add user. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaLengkapController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama Lengkap is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalLahirController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      // Validasi umur minimal 18 tahun
                      if (pickedDate != null) {
                        DateTime currentDate = DateTime.now();
                        DateTime minimumDate = DateTime(currentDate.year - 18,
                            currentDate.month, currentDate.day);

                        if (pickedDate.isAfter(minimumDate)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Minimum age requirement is 18 years old'),
                            ),
                          );
                        } else {
                          setState(() {
                            _tanggalLahirController.text =
                                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          });
                        }
                      }
                    },
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Tanggal Lahir is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tempatTinggalController,
                decoration: InputDecoration(labelText: 'Tempat Tinggal'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Tempat Tinggal is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _tambahPengguna,
                child: Text('Tambah Pengguna'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
