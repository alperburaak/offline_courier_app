import 'package:flutter/material.dart';
import 'package:offline_courier_app/core/services/auth_service.dart';
import 'package:offline_courier_app/core/utils/appbar.dart';
import 'package:offline_courier_app/providers/delivery_provider.dart';
import 'package:offline_courier_app/ui/pages/login_page.dart';
import 'package:offline_courier_app/ui/pages/scan_page.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Siparişleri sadece sayfa açıldığında çekiyoruz
    Provider.of<DeliveryProvider>(context, listen: false).getUserDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DeliveryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.deliveries.isEmpty) {
            return Center(child: Text("Siparişiniz bulunmamaktadır."));
          }

          return ListView.builder(
            itemCount: provider.deliveries.length,
            itemBuilder: (context, index) {
              var order = provider.deliveries[index];
              return Card(
                child: ListTile(
                  title: Text("Barkod: ${order['barcode']}"),
                  subtitle: Text("Durum: ${order['status']}"),
                  trailing: Text(
                    order['deliveryDate'].toString().split('T')[0],
                  ),
                ),
              );
            },
          );
        },
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
