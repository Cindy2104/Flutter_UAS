import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pajria_flutter_mi2a_uas/model/Model_Klinik.dart';
import 'dart:convert';
import 'list_data_klinik.dart';

class TambahDataKlinik extends StatefulWidget {
  final ModelKlinik? data;

  const TambahDataKlinik({Key? key, this.data}) : super(key: key);

  @override
  State<TambahDataKlinik> createState() => _TambahDataKlinikState();
}

class _TambahDataKlinikState extends State<TambahDataKlinik> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController jenisController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      namaController.text = widget.data!.nama;
      alamatController.text = widget.data!.alamat;
      teleponController.text = widget.data!.telepon;
      jenisController.text = widget.data!.jenis;
      latController.text = widget.data!.latitude.toString();
      longController.text = widget.data!.longitude.toString();
    }
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final model = ModelKlinik(
      id: widget.data?.id ?? 0,
      nama: namaController.text,
      alamat: alamatController.text,
      telepon: teleponController.text,
      jenis: jenisController.text,
      latitude: double.tryParse(latController.text) ?? 0.0,
      longitude: double.tryParse(longController.text) ?? 0.0,
      createdAt: widget.data?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    http.Response response;
    if (widget.data == null) {
      response = await http.post(
        Uri.parse('http://10.126.141.53:8000/api/kliniks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(model.toJson()),
      );
    } else {
      response = await http.put(
        Uri.parse('http://10.126.141.53:8000/api/kliniks/${model.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(model.toJson()),
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ListDataKlinik()),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D8C4),
      appBar: AppBar(
        title: Text(widget.data == null ? 'Tambah Data Klinik' : 'Edit Data Klinik'),
        backgroundColor: const Color(0xFF561C24),
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Klinik',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_hospital),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: alamatController,
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.import_contacts),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Alamat wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: teleponController,
                        decoration: const InputDecoration(
                          labelText: 'No Telepon',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'No Telepon wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: jenisController,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Klinik (Umum / Spesialis)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.merge_type),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Jenis wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: latController,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.satellite_alt),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Latitude wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: longController,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.satellite_alt_outlined),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Longitude wajib diisi' : null,
                      ),
                      const SizedBox(height: 28),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: simpanData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF561C24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  widget.data == null ? 'Simpan' : 'Update',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
