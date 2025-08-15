import 'package:crud_application/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


void main() {
  databaseFactory = databaseFactoryFfiWeb;
  sqfliteFfiInit();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const myapp());
}
class myapp extends StatelessWidget {
  const myapp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomePage(),
    );
  }
}