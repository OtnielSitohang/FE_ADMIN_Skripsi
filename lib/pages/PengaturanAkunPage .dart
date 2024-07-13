import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontadmin/models/UserProvider.dart';
import 'dart:convert';

class PengaturanAkunPage extends StatefulWidget {
  @override
  _PengaturanAkunPageState createState() => _PengaturanAkunPageState();
}

class _PengaturanAkunPageState extends State<PengaturanAkunPage> {
  late TextEditingController _emailController;
  late TextEditingController _tempatTinggalController;
  bool _isEmailEdited = false;
  bool _isTempatTinggalEdited = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers when the widget is first created
    _emailController = TextEditingController();
    _tempatTinggalController = TextEditingController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        _emailController.text = user.email;
        _tempatTinggalController.text = user.tempatTinggal;
      }
    });
  }

  @override
  void dispose() {
    // Dispose of controllers properly
    _emailController.dispose();
    _tempatTinggalController.dispose();
    super.dispose();
  }

  void _updateUser() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUser = userProvider.user!.copyWith(
      email: _emailController.text,
      tempatTinggal: _tempatTinggalController.text,
    );

    userProvider.updateUser(updatedUser);
    Navigator.pop(context); // Close the page after update
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      IconData icon, bool isEdited, Function(String) onChanged) {
    return ListTile(
      title: Text(label),
      subtitle: TextField(
        controller: controller,
        enabled: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(icon),
            onPressed: () {
              setState(() {
                // Toggle the edit state
                if (label == 'Email') {
                  _isEmailEdited = !_isEmailEdited;
                } else if (label == 'Tempat Tinggal') {
                  _isTempatTinggalEdited = !_isTempatTinggalEdited;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pengaturan Akun'),
        ),
        body: Center(child: Text('No user data available')),
      );
    }

    DateTime birthdate = DateTime.parse(user.tanggalLahir);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Akun'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pilih Sumber Gambar'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Galeri'),
                              onTap: () {
                                // _getImage(ImageSource.gallery);
                                // Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Kamera'),
                              onTap: () {
                                // _getImage(ImageSource.camera);
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 50,
                // backgroundImage: MemoryImage(base64Decode(user.fotoBase64)),
              ),
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text('Username'),
            subtitle: Text(user.username),
            enabled: false,
          ),
          ListTile(
            title: Text('Nama Lengkap'),
            subtitle: Text(user.namaLengkap),
            enabled: false,
          ),
          ListTile(
            title: Text('Tanggal Lahir'),
            subtitle: Text(
                '${birthdate.day} ${_getMonthName(birthdate.month)} ${birthdate.year}'),
            enabled: false,
          ),
          _buildEditableField(
              'Email', _emailController, Icons.edit, _isEmailEdited, (value) {
            setState(() {
              _isEmailEdited = value != user.email;
            });
          }),
          _buildEditableField('Tempat Tinggal', _tempatTinggalController,
              Icons.edit, _isTempatTinggalEdited, (value) {
            setState(() {
              _isTempatTinggalEdited = value != user.tempatTinggal;
            });
          }),
          ListTile(
            title: Text('Role'),
            subtitle: Text(user.role),
            enabled: false,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                (_isEmailEdited || _isTempatTinggalEdited) ? _updateUser : null,
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }
}
