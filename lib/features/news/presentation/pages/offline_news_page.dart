import 'package:flutter/material.dart';

class OfflineNewsPage extends StatelessWidget {
  const OfflineNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Offline (Cache)'),
        backgroundColor: Colors.amber.shade800,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 100, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            const Text(
              'Mode Offline Aktif',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: Text(
                'Menampilkan data berita terakhir yang tersimpan di Isar Database lokal Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder tempat list cache Isar akan dirender nanti
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Dummy count sebelum Isar terpasang
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.storage, color: Colors.amber),
                      title: Text('Berita Offline Cache #$index (Dari Isar)'),
                      subtitle: const Text('Dibaca secara instan dari penyimpanan lokal device.'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}