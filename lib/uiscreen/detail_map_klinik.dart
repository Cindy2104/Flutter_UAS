import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pajria_flutter_mi2a_uas/model/Model_Klinik.dart';

class DetailMapKlinik extends StatefulWidget {
  final ModelKlinik klinik;

  const DetailMapKlinik({Key? key, required this.klinik}) : super(key: key);

  @override
  State<DetailMapKlinik> createState() => _DetailMapKlinikState();
}

class _DetailMapKlinikState extends State<DetailMapKlinik> {
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng posisi = LatLng(widget.klinik.latitude, widget.klinik.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.klinik.nama),
        backgroundColor: const Color(0xFF561C24),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: posisi, zoom: 15),
            markers: {
              Marker(
                markerId: const MarkerId('klinik'),
                position: posisi,
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    Container(
                      width: 230,
                      height: 200,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D8C4),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.klinik.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF561C24),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.red),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.klinik.alamat,
                                    style: const TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.local_hospital, size: 16, color: Color(0xFF561C24)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Jenis: ${widget.klinik.jenis}',
                                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16, color: Color(0xFF561C24)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.klinik.telepon,
                                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    posisi,
                  );
                },
              ),
            },
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 140,
            width: 250,
            offset: 40,
          ),
        ],
      ),
    );
  }
}
