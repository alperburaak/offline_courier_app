import 'package:flutter/material.dart';
import 'package:offline_courier_app/providers/delivery_provider.dart';
import 'package:offline_courier_app/ui/pages/scan_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deliveryProvider = Provider.of<DeliveryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Teslimatlar')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: deliveryProvider.getAllDeliveries(),
              builder: (
                context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Bir hata oluştu: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Henüz teslimat yok.'));
                } else {
                  List<Map<String, dynamic>> deliveries = snapshot.data!;
                  return ListView.builder(
                    itemCount: deliveries.length,
                    itemBuilder: (context, index) {
                      var delivery = deliveries[index];
                      return ListTile(
                        title: Text(delivery['barcode'] ?? 'Barkod Bulunamadı'),
                        subtitle: Text('Adres: ${delivery['address']}'),
                        trailing: Text('Durum: ${delivery['status']}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanPage()),
          );
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
