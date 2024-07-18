class Booking {
  final int id;
  final String penggunaId;
  final String jenis_lapangan;
  final String nama_lapangan;
  final String nama_pengguna;
  final String lapanganId;
  final String jenisLapanganId;
  final String tanggalBooking;
  final String tanggalPenggunaan;
  final String sesi;
  final String buktiPembayaran;
  final String statusKonfirmasi;
  final String? voucherId; // Gunakan tipe nullable jika mungkin null

  Booking({
    required this.id,
    required this.penggunaId,
    required this.jenis_lapangan,
    required this.nama_lapangan,
    required this.nama_pengguna,
    required this.lapanganId,
    required this.jenisLapanganId,
    required this.tanggalBooking,
    required this.tanggalPenggunaan,
    required this.sesi,
    required this.buktiPembayaran,
    required this.statusKonfirmasi,
    required this.voucherId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      jenis_lapangan: json['jenis_lapangan'],
      nama_lapangan: json['nama_lapangan'],
      penggunaId: json['pengguna_id'].toString(), // Ubah ke String jika perlu
      nama_pengguna:
          json['nama_pengguna'].toString(), // Ubah ke String jika perlu
      lapanganId: json['lapangan_id'].toString(), // Ubah ke String jika perlu
      jenisLapanganId:
          json['jenis_lapangan_id'].toString(), // Ubah ke String jika perlu
      tanggalBooking: json['tanggal_booking'],
      tanggalPenggunaan: json['tanggal_penggunaan'],
      sesi: json['sesi'],
      buktiPembayaran: json['bukti_pembayaran'],
      statusKonfirmasi:
          json['status_konfirmasi'].toString(), // Ubah ke String jika perlu
      voucherId: json['voucher_id']
          ?.toString(), // Gunakan ? untuk mengatasi jika voucher_id bisa null
    );
  }
}
