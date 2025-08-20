import 'dart:async';
import 'package:crud_application/api_help/api_service.dart';
import 'package:crud_application/debouncer.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductList> {
  final Debouncer _debouncer = Debouncer(Duration(milliseconds: 200));
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final products = await ApiService.getProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      final filtered = _products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _filteredProducts = filtered;});});
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 5, 8),
        centerTitle: true,
        title: Text('Products Store'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(child: CircularProgressIndicator()): ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];
                      return ListTile(
                        leading: Image.network(p.image, width: 50),
                        title: Text(p.title),
                        trailing: Text('\{p.price.toStringAsFixed(2)}'),
);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
