// To parse this JSON data, do
//
//     final modelKlinik = modelKlinikFromJson(jsonString);

import 'dart:convert';

List<ModelKlinik> modelKlinikFromJson(String str) =>
    List<ModelKlinik>.from(json.decode(str).map((x) => ModelKlinik.fromJson(x)));

String modelKlinikToJson(List<ModelKlinik> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelKlinik {
  int id;
  String nama;
  String alamat;
  String telepon;
  String jenis;
  double latitude;
  double longitude;
  DateTime createdAt;
  DateTime updatedAt;

  ModelKlinik({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.jenis,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelKlinik.fromJson(Map<String, dynamic> json) => ModelKlinik(
        id: json["id"],
        nama: json["nama"],
        alamat: json["alamat"],
        telepon: json["telepon"],
        jenis: json["jenis"],
        latitude: (json["latitude"] is int)
            ? (json["latitude"] as int).toDouble()
            : double.tryParse(json["latitude"].toString()) ?? 0.0,
        longitude: (json["longitude"] is int)
            ? (json["longitude"] as int).toDouble()
            : double.tryParse(json["longitude"].toString()) ?? 0.0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "alamat": alamat,
        "telepon": telepon,
        "jenis": jenis,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
