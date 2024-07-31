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

class BookingPerMonth {
  final String bulan;
  final int jumlahBooking;

  BookingPerMonth({required this.bulan, required this.jumlahBooking});

  factory BookingPerMonth.fromJson(Map<String, dynamic> json) {
    return BookingPerMonth(
      bulan: json['bulan'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}

class BookingPerJenisLapangan {
  final String jenisLapangan;
  final int jumlahBooking;

  BookingPerJenisLapangan({required this.jenisLapangan, required this.jumlahBooking});

  factory BookingPerJenisLapangan.fromJson(Map<String, dynamic> json) {
    return BookingPerJenisLapangan(
      jenisLapangan: json['jenis_lapangan'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}

class RevenuePerMonth {
  final String bulan;
  final int totalPendapatan;

  RevenuePerMonth({required this.bulan, required this.totalPendapatan});

  factory RevenuePerMonth.fromJson(Map<String, dynamic> json) {
    return RevenuePerMonth(
      bulan: json['bulan'],
      totalPendapatan: json['total_pendapatan'],
    );
  }
}

class BookingByStatus {
  final int statusKonfirmasi;
  final int jumlahBooking;

  BookingByStatus({required this.statusKonfirmasi, required this.jumlahBooking});

  factory BookingByStatus.fromJson(Map<String, dynamic> json) {
    return BookingByStatus(
      statusKonfirmasi: json['status_konfirmasi'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}

class BookingPerUser {
  final String username;
  final int jumlahBooking;

  BookingPerUser({required this.username, required this.jumlahBooking});

  factory BookingPerUser.fromJson(Map<String, dynamic> json) {
    return BookingPerUser(
      username: json['username'],
      jumlahBooking: json['jumlah_booking'],
    );
  }
}
