import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/env_config.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EnvConfig.appName), // Memunculkan Nama sesuai Flavor
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.newspaper, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'DigiNews [${EnvConfig.environment}] Siap!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/profile'),
              child: const Text('Ke Halaman Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.push('/offline'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade100),
              child: const Text('Cek Berita Offline (Isar Cache)', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.push('/detail', extra: {
                'title': 'EAS Mobile Programming Lanjut Berbasis Anti-AI',
                'content': 'Mahasiswa dengan NPM 20123009 mengimplementasikan Clean Architecture dengan sukses untuk portal berita DigiNews Offline-First.',
                'imageUrl': 'https://picsum.photos/800/400'
              }),
              child: const Text('Uji Masuk Detail Berita'),
            ),
          ],
        ),
      ),
    );
  }
}