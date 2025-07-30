import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_manager.dart';

List<Widget> buildGridCard(BuildContext context) {
  final productManager = Provider.of<ProductManager>(context);
  final products = productManager.products;

  return List.generate(products.length, (int index) {
    final product = products[index];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: {
            'id': product.id,
            'imagePath': product.imagePath,
            'title': product.title,
            'subtitle': product.subtitle,
            'price': product.price,
            'rating': product.rating,
            'sizes': product.sizes,
            'description': product.description,
          },
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 165,
                child: product.imagePath.startsWith('images/')
                    ? Image.asset(
                        product.imagePath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(product.imagePath),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 8, 26, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                        Spacer(),
                        Text(
                          product.price,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            product.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.star, color: Colors.amber),
                          Text('(${product.rating})', textAlign: TextAlign.end),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}