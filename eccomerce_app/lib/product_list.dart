import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'product_manager.dart';

List<Widget> buildGridCard(BuildContext context) {
  final ProductManager productManager = Provider.of<ProductManager>(context);
  final List<Product> products = productManager.products;

  return List<Widget>.generate(products.length, (int index) {
    final Product product = products[index];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: <String, Object>{
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
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            product.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.amber),
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