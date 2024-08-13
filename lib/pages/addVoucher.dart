// lib/pages/add_voucher_page.dart

import 'package:flutter/material.dart';
import 'package:frontadmin/services/voucher_service.dart'; // Ganti dengan path yang benar

class AddVoucherPage extends StatefulWidget {
  const AddVoucherPage({super.key});

  @override
  _AddVoucherPageState createState() => _AddVoucherPageState();
}

class _AddVoucherPageState extends State<AddVoucherPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _diskonController = TextEditingController();
  DateTime _tanggalMulai = DateTime.now();
  DateTime _tanggalSelesai = DateTime.now().add(const Duration(days: 30));
  int _batasPenggunaan = 100;

  final VoucherService _voucherService = VoucherService();
  bool _isSubmitting = false;
  String _errorMessage = '';

  void _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _tanggalMulai : _tanggalSelesai,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != (isStartDate ? _tanggalMulai : _tanggalSelesai)) {
      setState(() {
        if (isStartDate) {
          _tanggalMulai = pickedDate;
        } else {
          _tanggalSelesai = pickedDate;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await _voucherService.addVoucher(
          kode: _kodeController.text,
          diskon: int.parse(_diskonController.text),
          status: 1,
          tanggalMulai: _tanggalMulai,
          tanggalSelesai: _tanggalSelesai,
          batasPenggunaan: _batasPenggunaan,
        );
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Voucher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _kodeController,
                  decoration: const InputDecoration(labelText: 'Voucher Code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a voucher code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _diskonController,
                  decoration: const InputDecoration(labelText: 'Discount (%)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a discount percentage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Start Date: ${_tanggalMulai.toLocal().toString().split(' ')[0]}'),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context, true),
                      child: const Text('Select Start Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('End Date: ${_tanggalSelesai.toLocal().toString().split(' ')[0]}'),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context, false),
                      child: const Text('Select End Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Usage Limit'),
                  keyboardType: TextInputType.number,
                  initialValue: _batasPenggunaan.toString(),
                  onChanged: (value) {
                    _batasPenggunaan = int.tryParse(value) ?? 0;
                  },
                ),
                const SizedBox(height: 16.0),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting 
                    ? const CircularProgressIndicator() 
                    : const Text('Add Voucher'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
