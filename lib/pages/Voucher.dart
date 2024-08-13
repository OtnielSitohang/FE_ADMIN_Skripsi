import 'package:flutter/material.dart';
import 'package:frontadmin/services/voucher_service.dart'; // Ganti dengan path yang benar

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  _VoucherPageState createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  late VoucherService _voucherService;
  List<dynamic> _vouchers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _voucherService = VoucherService();
    _fetchVouchers();
  }

  Future<void> _fetchVouchers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final vouchers = await _voucherService.fetchVouchers();
      setState(() {
        _vouchers = vouchers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshVouchers() async {
    await _fetchVouchers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshVouchers, // Call refresh function
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/add-voucher'); // Navigate to add voucher page
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text('Error: $_errorMessage'))
              : ListView.builder(
                  itemCount: _vouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = _vouchers[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.card_giftcard, color: Colors.blue),
                        title: Text(voucher['kode']),
                        subtitle: Text('Discount: ${voucher['diskon']}%'),
                        trailing: Text(
                          voucher['status'] == 1 ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: voucher['status'] == 1
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        onTap: () {
                          // Implement action on tap if needed
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
