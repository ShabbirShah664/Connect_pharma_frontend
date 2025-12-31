import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect-Pharma',
      theme: AppTheme.lightTheme, 
      
      // FIX 2: Use the 'intro' route
      initialRoute: AppRoutes.initialRoute, 
      
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}