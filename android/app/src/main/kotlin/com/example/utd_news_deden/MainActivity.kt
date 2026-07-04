package com.example.utd_news_deden

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.utd_news_deden/nim_reverser"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Mencocokkan nama method yang dipanggil dari Dart
            if (call.method == "reverseNIM") {
                val nim = call.argument<String>("nim")
                
                if (nim != null) {
                    // TANTANGAN ANTI-AI: Membalikkan urutan String NIM (Contoh: 20123009 -> 90032102)
                    val reversedNim = nim.reversed()
                    
                    // Memunculkan Native Toast Android langsung dari OS
                    Toast.makeText(this, "Native Android Toast: $reversedNim", Toast.LENGTH_LONG).show()
                    
                    // Mengembalikan nilai sukses kembali ke layer Dart/Flutter
                    result.success(reversedNim)
                } else {
                    result.error("INVALID_ARGUMENT", "NIM bernilai null atau kosong", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}