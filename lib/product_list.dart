import 'dart:async';

import 'package:crud_application/api_help/api_service.dart';
import 'package:crud_application/card_page.dart';
import 'package:crud_application/debouncer.dart';
import 'package:flutter/material.dart';
import 'product.dart';



class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductListState();
}
 class _ProductListPageState extends State<ProductListPage> {
  final Debouncer _debouncer = Debouncer(Duration(milliseconds: 500));
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
      final filtered = _products.where((product) =>
        product.title.toLowerCase().contains(query.toLowerCase())
      ).toList();

      setState(() {
        _filteredProducts = filtered;
      });
    });
  }

  @override
  void dispose() {_debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 5, 8),
        centerTitle: true,
        title: Text(' Products Strore'),
      ),
      body: FutureBuilder<List<Product>>(
        future: ApiService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return ListTile(
                  leading: Image.network(p.image, width: 50),
                  title: Text(p.title),

                  trailing: Text('\$${p.price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Text(p.title),
                            backgroundColor: const Color.fromARGB(
                              255,
                              98,
                              5,
                              8,
                            ),
                          ),
                        
                          body: Column(
                            children: [
                              Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
              ),
            ),
          ),  
                   Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('\{product.price}'),
                );
              },
            ),
          ),
                              Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(p.image),
                                      Text(p.description),
                                      Text('\$${p.price.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          bottomNavigationBar: SingleChildScrollView(
                            child: BottomAppBar(
                              color: const Color.fromARGB(255, 98, 5, 8),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CardPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.home, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

