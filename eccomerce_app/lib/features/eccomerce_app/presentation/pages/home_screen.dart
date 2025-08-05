import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/product_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(const LoadAllProductsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          text: 'Yohannes, ',
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
            const SizedBox(width: 10),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: SizedBox(
              height: 20,
            ),
          ),
        ),
        body: const ProductList(),
      ),
    );
  }


}