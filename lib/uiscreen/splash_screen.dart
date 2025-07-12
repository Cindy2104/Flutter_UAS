import 'package:flutter/material.dart';
import 'package:pajria_flutter_mi2a_uas/uiscreen/list_data_klinik.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ListDataKlinik()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF561C24),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.local_hospital,
              size: 80,
              color: Color(0xFFE8D8C4), // cream
            ),
            SizedBox(height: 20),
            Text(
              "MI2A Klinik",
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFFE8D8C4),
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
