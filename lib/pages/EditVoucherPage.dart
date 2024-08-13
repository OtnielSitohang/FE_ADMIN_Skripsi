import 'package:flutter/material.dart';
import 'package:frontadmin/services/voucher_service.dart';

class EditVoucherPage extends StatefulWidget {
  final Map<String, dynamic> voucher;

  const EditVoucherPage({required this.voucher, Key? key}) : super(key: key);

  @override
  _EditVoucherPageState createState() => _EditVoucherPageState();
}

class _EditVoucherPageState extends State<EditVoucherPage> {
  final _formKey = GlobalKey<FormState>();
  late String _kode;
  late int _diskon;
  late int _status;
  late DateTime _tanggalSelesai;
  late int _batasPenggunaan;
  late VoucherService _voucherService;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _kode = widget.voucher['kode'];
    _diskon = widget.voucher['diskon'];
    _status = widget.voucher['status'];
    _tanggalSelesai = DateTime.parse(widget.voucher['tanggal_selesai']);
    _batasPenggunaan = widget.voucher['batas_penggunaan'];
    _voucherService = VoucherService();
  }

  Future<void> _updateVoucher() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        await _voucherService.updateVoucher(
          id: widget.voucher['id'],
          kode: _kode,
          diskon: _diskon,
          status: _status,
          tanggalSelesai: _tanggalSelesai.toIso8601String(),
          batasPenggunaan: _batasPenggunaan,
        );
        Navigator.pop(context, true); // Indicate successful update
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _tanggalSelesai,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _tanggalSelesai) {
      setState(() {
        _tanggalSelesai = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Voucher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _kode,
                decoration: const InputDecoration(labelText: 'Kode'),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _kode = value;
                  }
                },
              ),
              TextFormField(
                initialValue: _diskon.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Diskon (%)'),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _diskon = int.parse(value);
                  }
                },
              ),
              TextFormField(
                initialValue: _batasPenggunaan.toString(),
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Batas Penggunaan'),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _batasPenggunaan = int.parse(value);
                  }
                },
              ),
              ListTile(
                title: const Text('Status'),
                trailing: DropdownButton<int>(
                  value: _status,
                  onChanged: (int? newValue) {
                    setState(() {
                      _status = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: 1, child: Text('Active')),
                    DropdownMenuItem(value: 0, child: Text('Inactive')),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Selesai',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _tanggalSelesai.toLocal().toString().split(' ')[0],
                    ),
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        _tanggalSelesai = DateTime.parse(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateVoucher,
                child: const Text('Update Voucher'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text('Error: $_errorMessage',
                      style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
