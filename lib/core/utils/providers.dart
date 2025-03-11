import 'package:offline_courier_app/providers/auth_provider.dart';
import 'package:offline_courier_app/providers/delivery_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => DeliveryProvider()),
  ChangeNotifierProvider(create: (context) => AuthProvider()),
];
