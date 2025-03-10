import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Barkodu ID olarak kullanarak teslimat bilgilerini Firestore'a kaydetme
  Future<void> addDelivery(
    String barcode,
    Map<String, dynamic> deliveryData,
  ) async {
    try {
      // Barkodu kullanarak Firestore'da yeni bir belge (document) oluşturuyoruz
      await _db.collection('deliveries').doc(barcode).set(deliveryData);
    } catch (e) {
      print("Error adding delivery: $e");
    }
  }

  // Kargo bilgilerini almak için Firestore'dan veri çekme
  Future<Map<String, dynamic>?> getDelivery(String barcode) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection('deliveries').doc(barcode).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return null; // Barkod bulunmazsa null dönebiliriz
      }
    } catch (e) {
      print("Error fetching delivery: $e");
      return null;
    }
  }

  // Tüm teslimat bilgilerini almak için
  Future<List<Map<String, dynamic>>> getAllDeliveries() async {
    try {
      QuerySnapshot snapshot = await _db.collection('deliveries').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching deliveries: $e");
      return [];
    }
  }
}
