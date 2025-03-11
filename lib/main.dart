import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:offline_courier_app/core/utils/providers.dart';
import 'package:offline_courier_app/core/utils/theme.dart';
import 'package:offline_courier_app/ui/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Offline Kargo Teslimatı',
        theme: appTheme,
        home: LoginPage(),
      ),
    );
  }
}
