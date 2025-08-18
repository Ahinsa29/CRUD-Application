import 'package:crud_application/api_help/api_service.dart';
import 'package:crud_application/card_page.dart';
import 'package:flutter/material.dart';
import 'product.dart';

void main() {
  runApp(MaterialApp(home: ProductList()));
}

class ProductList extends StatelessWidget {
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
                          body: Center(
                            child:SingleChildScrollView(
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
                          bottomNavigationBar: BottomAppBar(
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
                                        builder: (context) =>CardPage(),
                                        
                                
                                      ),
                                    );
                                  },
                                  
                                  
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                 icon:  Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  ),),
                              ],
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
