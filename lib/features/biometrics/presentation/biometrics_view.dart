import 'package:flutter/material.dart';
import 'package:porkapp/shared/widgets/main_bottom_navigation_bar.dart';

class BiometricsView extends StatelessWidget {
  const BiometricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometrías'), centerTitle: true),
      body: const Center(child: Text('Próximamente: Control de biometrías')),
      bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 3),
    );
  }
}
