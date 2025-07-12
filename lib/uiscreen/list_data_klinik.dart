import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pajria_flutter_mi2a_uas/model/Model_Klinik.dart';
import 'dart:convert';
import 'detail_klinik.dart';
import 'tambah_data_klinik.dart';

class ListDataKlinik extends StatefulWidget {
  const ListDataKlinik({super.key});

  @override
  State<ListDataKlinik> createState() => _ListDataKlinikState();
}

class _ListDataKlinikState extends State<ListDataKlinik> {
  late Future<List<ModelKlinik>> futureKlinik;

  @override
  void initState() {
    super.initState();
    futureKlinik = fetchKlinik();
  }

  Future<List<ModelKlinik>> fetchKlinik() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.126.141.53:8000/api/kliniks'),
      );
      if (response.statusCode == 200) {
        return modelKlinikFromJson(response.body);
      } else {
        throw Exception('Gagal memuat data klinik');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  Future<void> deleteKlinik(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.126.141.53:8000/api/kliniks/$id'),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          futureKlinik = fetchKlinik();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Klinik berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus data Klinik')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D8C4),
      appBar: AppBar(
        title: const Text('Daftar Klinik'),
        backgroundColor: const Color(0xFF561C24),
        elevation: 1,
      ),
      body: FutureBuilder<List<ModelKlinik>>(
        future: futureKlinik,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data Klinik kosong'));
          }

          final klinikList = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                futureKlinik = fetchKlinik();
              });
              await futureKlinik;
            },
            child: ListView.builder(
              itemCount: klinikList.length,
              itemBuilder: (context, index) {
                final klinik = klinikList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 4,
                  color: const Color(0xFFF6EEE0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailKlinik(klinik: klinik),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF6D2932),
                            child: const Icon(
                              Icons.local_hospital,
                              color: Color(0xFFE8D8C4),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  klinik.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Color(0xFF561C24),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC7B7A3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    klinik.jenis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF561C24),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        klinik.alamat,
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      klinik.telepon,
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.map, size: 16, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Lat: ${klinik.latitude}, Long: ${klinik.longitude}',
                                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF6D2932)),
                                tooltip: 'Edit',
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TambahDataKlinik(data: klinik),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {
                                      futureKlinik = fetchKlinik();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Hapus',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi Hapus'),
                                      content: Text('Yakin ingin menghapus "${klinik.nama}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await deleteKlinik(klinik.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahDataKlinik(),
            ),
          );
          if (result == true) {
            setState(() {
              futureKlinik = fetchKlinik();
            });
          }
        },
        backgroundColor: const Color(0xFF561C24),
        child: const Icon(Icons.add_location_alt, color: Colors.white),
        tooltip: 'Tambah Klinik',
      ),
    );
  }
}
