import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offline_courier_app/core/services/delivery_service.dart';

class DeliveryProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Map<String, dynamic>> deliveries = [];

  Future<void> addDelivery(
    String barcode,
    Map<String, dynamic> deliveryData,
  ) async {
    try {
      await DeliveryService().addDelivery(barcode, deliveryData);
    } catch (e) {
      throw Exception('Veri kaydetme hatası: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserDeliveries() async {
    try {
      isLoading = true;
      notifyListeners();

      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        deliveries = [];
        return [];
      }

      // Kullanıcının kendi siparişlerini getir
      List<Map<String, dynamic>> result = await DeliveryService()
          .getUserDeliveries(userId);

      deliveries = result;
      return deliveries;
    } catch (e) {
      throw Exception('Veri getirme hatası: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
