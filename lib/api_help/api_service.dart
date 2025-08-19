import 'dart:convert';
import 'package:crud_application/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  
   Future<Product> createProduct(String title, double price, String description, String image, String category) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode({
        'title': title,
        'price': price,
        'description': description,
        'image': image,
        'category': category
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }
  static Future<void> deleteProduct(int id) async {
    await http.delete(Uri.parse('baseUrl/id'));
  }

}

