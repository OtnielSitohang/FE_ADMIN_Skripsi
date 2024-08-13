import 'package:flutter/material.dart';
import 'package:frontadmin/services/voucher_service.dart'; // Ganti dengan path yang benar
import 'package:intl/intl.dart'; // Import untuk format tanggal

class AddVoucherPage extends StatefulWidget {
  @override
  _AddVoucherPageState createState() => _AddVoucherPageState();
}

class _AddVoucherPageState extends State<AddVoucherPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _diskonController = TextEditingController();
  final _statusController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalSelesaiController = TextEditingController();
  final _batasPenggunaanController = TextEditingController();

  late VoucherService _voucherService;

  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;

  @override
  void initState() {
    super.initState();
    _voucherService = VoucherService();
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, DateTime? initialDate,
      {bool isEndDate = false}) async {
    DateTime now = DateTime.now();
    DateTime effectiveInitialDate = initialDate ?? now;
    DateTime? minDate;

    if (isEndDate && _tanggalMulai != null) {
      minDate = _tanggalMulai!.add(Duration(days: 1)); // Set minimum date for end date
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate,
      firstDate: now, // Tanggal mulai tidak boleh kemarin
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
          ),
          child: child!,
        );
      },
      selectableDayPredicate: (DateTime date) {
        if (isEndDate && minDate != null) {
          return date.isAfter(minDate!.subtract(Duration(days: 1)));
        }
        return true;
      },
    );

    if (picked != null && picked != effectiveInitialDate) {
      if (isEndDate && picked.isBefore(now)) {
        // Jika tanggal selesai dipilih dan kurang dari hari ini
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Invalid Date'),
            content: Text('Tanggal selesai tidak boleh kurang dari hari ini.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (controller == _tanggalSelesaiController &&
          _tanggalMulai != null &&
          picked.isBefore(_tanggalMulai!)) {
        // Jika tanggal selesai sebelum tanggal mulai
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Invalid Date'),
            content: Text('Tanggal selesai tidak boleh sebelum tanggal mulai.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        if (controller == _tanggalMulaiController) {
          _tanggalMulai = picked;
        } else if (controller == _tanggalSelesaiController) {
          _tanggalSelesai = picked;
        }
      });
    }
  }

  Future<void> _addVoucher() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final kode = _kodeController.text;
        final diskon = int.parse(_diskonController.text);
        final status = int.parse(_statusController.text);
        final batasPenggunaan = int.parse(_batasPenggunaanController.text);

        if (_tanggalMulai != null && _tanggalSelesai != null) {
          DateTime now = DateTime.now();

          if (_tanggalMulai!.isAfter(_tanggalSelesai!)) {
            throw Exception('Tanggal mulai tidak boleh setelah tanggal selesai.');
          }
          if (_tanggalMulai!.isAtSameMomentAs(_tanggalSelesai!)) {
            throw Exception('Tanggal selesai tidak boleh sama dengan tanggal mulai.');
          }
          if (_tanggalSelesai!.isBefore(now)) {
            throw Exception('Tanggal selesai tidak boleh kurang dari hari ini.');
          }
          if (_tanggalSelesai!.isBefore(_tanggalMulai!.add(Duration(days: 1)))) {
            throw Exception('Tanggal selesai harus minimal satu hari setelah tanggal mulai.');
          }
        }

        await _voucherService.addVoucher(
          kode: kode,
          diskon: diskon,
          status: status,
          tanggalMulai: _tanggalMulai!,
          tanggalSelesai: _tanggalSelesai!,
          batasPenggunaan: batasPenggunaan,
        );

        Navigator.pop(context, true); // Kembali ke halaman sebelumnya dan beri tahu bahwa voucher telah ditambahkan
      } catch (e) {
        // Handle error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add voucher: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Voucher'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _kodeController,
                decoration: InputDecoration(
                  labelText: 'Kode',
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter voucher code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _diskonController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Diskon (%)',
                  prefixIcon: Icon(Icons.percent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.info),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter status';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(
                    context, _tanggalMulaiController, _tanggalMulai),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _tanggalMulaiController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Mulai',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter start date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(
                    context, _tanggalSelesaiController, _tanggalSelesai,
                    isEndDate: true),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _tanggalSelesaiController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Selesai',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter end date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: _batasPenggunaanController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Batas Penggunaan',
                  prefixIcon: Icon(Icons.exposure),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter usage limit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addVoucher,
                child: Text('Add Voucher'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
