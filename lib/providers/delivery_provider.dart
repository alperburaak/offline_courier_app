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

  Future<List<Map<String, dynamic>>> getAllDeliveries() async {
    try {
      isLoading = true;
      List<Map<String, dynamic>> result =
          await DeliveryService().getAllDeliveries();
      if (result != null) {
        deliveries = result;
      } else {
        deliveries = [];
      }
      return deliveries;
    } catch (e) {
      throw Exception('Veri getirme hatası: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
