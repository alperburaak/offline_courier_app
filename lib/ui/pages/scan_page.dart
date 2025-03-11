import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:offline_courier_app/providers/delivery_provider.dart';
import 'package:offline_courier_app/ui/pages/home_page.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _isProcessing =
      false; // Barkod tarandıktan sonra tekrar tetiklenmemesi için
  bool _isFlashOn = false; // Flash durumu
  bool _isCameraFront = false; // Kamera yönü
  MobileScannerController cameraController = MobileScannerController();

  // Flash açma ve kapama
  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    cameraController.toggleTorch();
  }

  // Kamera değiştirme
  void _toggleCamera() {
    setState(() {
      _isCameraFront = !_isCameraFront;
    });
    cameraController.switchCamera(); // Kamerayı değiştir
  }

  // Firebase'e veri kaydetme fonksiyonu
  Future<void> _saveToFirestore(String barcode) async {
    try {
      await context.read<DeliveryProvider>().addDelivery(barcode, {
        'barcode': barcode,
        'status': 'Teslim Edildi',
        'address': 'İstanbul, Türkiye',
      }); // addDelivery fonksiyonunu servis üzerinden çağırıyoruz
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Teslimat başarıyla kaydedildi')));
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kaydetme sırasında hata oluştu')));
    }
  }

  // Onay diyalog kutusu gösterme fonksiyonu
  void _showConfirmationDialog(String barcode) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Barkod Tarandı"),
            content: Text("Barkod: $barcode"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Sadece popup'ı kapat
                },
                child: Text("İptal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _saveToFirestore(barcode); // Firebase'e kaydet
                  Navigator.pop(context); // Popup'ı kapat
                  Navigator.pop(context); // Barkod sayfasını kapat ve geri dön
                },
                child: Text("Onayla"),
              ),
            ],
          ),
    );
  }

  // Manuel giriş fonksiyonu
  void _manualBarcodeEntry() {
    final TextEditingController barcodeController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Manuel Barkod Girişi"),
            content: TextField(
              controller: barcodeController,
              decoration: InputDecoration(hintText: 'Barkod Numarasını Girin'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Sadece popup'ı kapat
                },
                child: Text("İptal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String barcode = barcodeController.text;
                  if (barcode.isNotEmpty) {
                    await _saveToFirestore(barcode); // Firebase'e kaydet
                    Navigator.pop(context); // Popup'ı kapat
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    ); // Ana sayfaya geri dön
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen barkod girin')),
                    );
                  }
                },
                child: Text("Onayla"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barkod Tara')),
      body: Stack(
        children: [
          // MobileScanner widget'ı ile kamera açıyoruz
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!_isProcessing) {
                _isProcessing = true; // Aynı barkodun tekrar okunmasını engelle
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  String barcodeValue =
                      barcodes.first.rawValue ?? 'Bilinmeyen Barkod';
                  _showConfirmationDialog(
                    barcodeValue,
                  ); // Barkodu göster ve Firebase'e kaydet
                }
              }
            },
          ),
          // Kılavuz Çizgileri
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 4,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Barkodunuzu\nYerleştirin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Flash ve Kamera Değiştirme Butonları
          Positioned(
            top: 40,
            right: 10,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFlash,
                ),
                IconButton(
                  icon: Icon(Icons.switch_camera, color: Colors.white),
                  onPressed: _toggleCamera,
                ),
                IconButton(
                  icon: Icon(
                    Icons.keyboard,
                    color: Colors.white,
                  ), // Manuel Giriş Butonu
                  onPressed: _manualBarcodeEntry,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
