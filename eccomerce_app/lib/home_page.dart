import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'product_list.dart';
import 'product_manager.dart';
import 'user_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final ProductManager productManager = Provider.of<ProductManager>(context);
    final List<Product> products = productManager.products;

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromRGBO(204, 204, 204, 1),
            ),
          ),
          title: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    text: 'July 14, 2023',
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: 'Hello, ',
                      style: const TextStyle(color: Colors.black),
                      children: <InlineSpan>[
                         TextSpan(
                          text: userData.getUserName(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromRGBO(221, 221, 221, 1)),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Color.fromRGBO(221, 221, 221, 1),
              ),
            ),
          ],
        ),
        body: products.isEmpty
            ? const Center(child: Text('No products available'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Available Products',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color.fromRGBO(221, 221, 221, 1),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/search');
                              },
                              child: const Icon(
                                Icons.search,
                                color: Color.fromRGBO(221, 221, 221, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (BuildContext context) => GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 3 / 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: buildGridCard(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add-product');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 12,
                          ),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(
                            color: Color.fromRGBO(132, 129, 129, 0.788),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              'Add Product',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 255, 255, 0.788),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
