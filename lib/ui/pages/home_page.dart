import 'package:flutter/material.dart';
import 'package:offline_courier_app/core/services/auth_service.dart';
import 'package:offline_courier_app/providers/delivery_provider.dart';
import 'package:offline_courier_app/ui/pages/login_page.dart';
import 'package:offline_courier_app/ui/pages/scan_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    DeliveryProvider deliveryProvider = Provider.of<DeliveryProvider>(
      context,
      listen: false,
    );
    deliveryProvider.getUserDeliveries();
  }

  Future<void> _logout() async {
    await AuthService().logoutUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siparişlerim"),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
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
