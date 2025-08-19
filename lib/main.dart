import 'package:crud_application/api_help/api_service.dart';
import 'package:flutter/material.dart';

import 'product.dart';
import 'debouncer.dart';

void main() {
  runApp(MaterialApp(home: ProductListPage()));
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
