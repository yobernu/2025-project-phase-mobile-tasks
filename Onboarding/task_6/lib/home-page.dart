import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user-data.dart';
import 'product_manager.dart';
import 'product-list.dart';

// imagepath
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final productManager = Provider.of<ProductManager>(context);
    final products = productManager.products;

    return Container(
      padding: EdgeInsets.all(16),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Color.fromRGBO(204, 204, 204, 1),
            ),
          ),
          title: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "July 14, 2023",
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Hello, ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: userData.getUserName(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color.fromRGBO(221, 221, 221, 1)),
              ),
              child: Icon(
                Icons.notifications_none,
                color: Color.fromRGBO(221, 221, 221, 1),
              ),
            ),
          ],
        ),
        body: products.isEmpty
            ? Center(child: Text('No products available'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
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
                                color: Color.fromRGBO(221, 221, 221, 1),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/search');
                              },
                              child: Icon(
                                Icons.search,
                                color: Color.fromRGBO(221, 221, 221, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) => GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 3 / 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: buildGridCard(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
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
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: const Text(
                              "Add Product",
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
