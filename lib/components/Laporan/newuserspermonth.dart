import 'package:flutter/material.dart';

// Model for NewUserData
class NewUserData {
  final String bulan;
  final int jumlahPenggunaBaru;

  NewUserData({required this.bulan, required this.jumlahPenggunaBaru});

  factory NewUserData.fromJson(Map<String, dynamic> json) {
    return NewUserData(
      bulan: json['bulan'],
      jumlahPenggunaBaru: json['jumlah_pengguna_baru'],
    );
  }
}

// Example Data (replace with actual API call in production)
final List<NewUserData> exampleNewUsersPerMonth = [
  NewUserData(bulan: "2024-08", jumlahPenggunaBaru: 11),
];

class NewUsersPerMonthCard extends StatelessWidget {
  final List<NewUserData> newUsersPerMonth;

  const NewUsersPerMonthCard({Key? key, required this.newUsersPerMonth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Jumlah Pengguna Baru Per Bulan',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            for (var user in newUsersPerMonth) ...[
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text(user.bulan),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('${user.jumlahPenggunaBaru}'),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
