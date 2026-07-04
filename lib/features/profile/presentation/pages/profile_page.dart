import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _channel = MethodChannel('com.example.utd_news_deden/nim_reverser');

  int _clickCount = 0;
  bool _showSecretLottie = false;
  DateTime? _lastClickTime;
  String _reversedNimResult = ""; 
  bool _isNativeLoading = false;

  Future<void> _invokeNativeReverseNim() async {
    setState(() {
      _isNativeLoading = true;
    });

    try {
      const myNim = "20123009"; 
      final String result = await _channel.invokeMethod('reverseNIM', {'nim': myNim});
      
      setState(() {
        _reversedNimResult = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _reversedNimResult = "Gagal memanggil Native: ${e.message}";
      });
    } finally {
      setState(() {
        _isNativeLoading = false;
      });
    }
  }

  void _handleProfileClick() {
    final now = DateTime.now();
    if (_lastClickTime != null && now.difference(_lastClickTime!).inMilliseconds > 800) {
      _clickCount = 0;
    }
    _lastClickTime = now;
    _clickCount++;

    if (_clickCount == 9) { 
      setState(() {
        _showSecretLottie = true;
        _clickCount = 0;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showSecretLottie = false);
      });
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ketukan cepat terdeteksi: $_clickCount/9'),
          duration: const Duration(milliseconds: 200),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF0A0F1D) : Colors.grey.shade50,
      appBar: AppBar(title: const Text('Profil Developer'), elevation: 0),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _handleProfileClick,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: theme.colorScheme.primary, width: 3)),
                      child: const CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.person_rounded, size: 70, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Deden Tio Zulfikri', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text('NPM: 20123009', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, letterSpacing: 1.0)),
                  ),
                  const SizedBox(height: 16),
                  Text('S1 Informatika\nUniversitas Teknologi Digital', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, height: 1.4)),
                  
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 20),
                  
                  ElevatedButton.icon(
                    onPressed: _isNativeLoading ? null : _invokeNativeReverseNim,
                    icon: _isNativeLoading 
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.android_rounded),
                    label: const Text('Picu Native Kotlin: Balikkan NIM'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (_reversedNimResult.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Hasil dari Native Dart:', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      _reversedNimResult,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: theme.colorScheme.primary, letterSpacing: 2.0), // Diperbaiki ke w900
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (_showSecretLottie)
            Container(
              color: Colors.black.withValues(alpha: 0.9),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_obhph3sh.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, size: 80, color: Colors.amber),
                      SizedBox(height: 16),
                      Text('💥 EASTER EGG NIM GANJIL AKTIF! 💥', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}