import 'package:crud_application/home_page.dart';
import 'package:crud_application/product_list.dart';
import 'package:flutter/material.dart';



void main() {


  runApp(const myapp());
}
class myapp extends StatelessWidget {
  const myapp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:ProductList(),
    );
  }
}