import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_pharma/models/product_model.dart';

import '../components/constants.dart';

class ProductDataProvider with ChangeNotifier {
  List<ProductModel> _productsList = [];
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> get productsList => _productsList;

  Future<void> fetchProductsList() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final productsList = querySnapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();
      if (productsList != _productsList) {
        _productsList = productsList;
        notifyListeners();
      }
    } catch (e) {
      print('Error in the fetch products function $e');
      return;
    }
  }

  static Future<void> addProduct({
    required String name,
    required int code,
    required double mrp,
    required double trp,
    required String packing,
  }) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState;
      try {
        showDialog(
            context: navigatorKey.currentContext!,
            builder: ((context) {
              return Builder(builder: (context) {
                return const Center(child: CircularProgressIndicator());
              });
            }));
        await _firestore.collection('products').add({
          'name': name,
          'code': code,
          'mrp': mrp,
          'trp': trp,
          'packing': packing,
        });
        Navigator.pop(navigatorKey.currentContext!);

        showCustomDialog(
            context: navigatorKey.currentContext!,
            title: 'Success',
            content: 'Product added successfully');

        print('product added to database');
      } on FirebaseException catch (e) {
        print('Error in the add product function $e');
        showCustomDialog(
            context: navigatorKey.currentContext!,
            title: 'Failure',
            content: 'An Error Occurred, Please Try again');
      }
    }
  }

  void updateProduct(String productId, ProductModel newProduct) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update(newProduct.toMap());
      notifyListeners();
    } catch (e) {
      print('Error in updating product: $e');
      return;
    }
  }

  void deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      notifyListeners();
    } catch (e) {
      print('Error in deleting product: $e');
      return;
    }
  }
}
