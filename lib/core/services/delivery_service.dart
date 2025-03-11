import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Barkodu ID olarak kullanarak teslimat bilgilerini Firestore'a kaydetme
  Future<void> addDelivery(
    String barcode,
    Map<String, dynamic> deliveryData,
  ) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(barcode)
        .set({
          'barcode': barcode,
          'status': 'Teslim Edildi',
          'deliveryDate': DateTime.now().toIso8601String(),
        });
  }

  // Kargo bilgilerini almak için Firestore'dan veri çekme
  Future<Map<String, dynamic>?> getDelivery(String barcode) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('deliveries').doc(barcode).get();
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
  Future<List<Map<String, dynamic>>> getUserDeliveries(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('orders')
              .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Siparişler getirilemedi: $e');
    }
  }
}
