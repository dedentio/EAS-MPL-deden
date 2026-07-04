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
          ],
        ),
      ),
    );
  }
}