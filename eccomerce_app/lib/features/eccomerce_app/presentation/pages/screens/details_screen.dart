import 'dart:io';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: widget.product.imagePath.startsWith('http')
                          ? Image.network(
                              widget.product.imagePath,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 50, color: Colors.grey);
                              },
                            )
                          : widget.product.imagePath.startsWith('images/')
                              ? Image.asset(
                                  widget.product.imagePath,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(widget.product.imagePath),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '<',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color.fromRGBO(221, 221, 221, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          widget.product.subtitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 170, 170, 170),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 215, 1),
                              size: 20,
                            ),
                            Text('(${widget.product.rating})'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Color.fromRGBO(62, 62, 62, 1),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.product.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Size:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.sizes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String size = widget.product.sizes[index];
                          final bool isSelected = selectedIndex == index;

                          return GestureDetector(
                            onTap: () => setState(() => selectedIndex = index),
                            child: Container(
                              width: 60,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isSelected
                                    ? const Color.fromRGBO(63, 81, 243, 1)
                                    : Colors.white,
                                border: Border.all(
                                  color: const Color.fromARGB(30, 0, 0, 0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        // DELETE BUTTON
                        TextButton(
                          onPressed: () {
                            // final ProductManager productManager = Provider.of<ProductManager>(
                            //   context,
                            //   listen: false
                            // );
                            // productManager.deleteProduct(product.id);
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 44,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                              color: Color.fromRGBO(255, 19, 19, 0.79),
                            ),
                          ),
                          child: const Text(
                            'DELETE',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 19, 19, 0.79),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // UPDATE BUTTON
                        TextButton(
                          onPressed: ()  {
                            // await Navigator.pushNamed(
                            //   context,
                            //   '/update-screen',
                            //   arguments: widget.product,
                            // );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              63,
                              81,
                              243,
                              1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 44,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 255, 255, 0.79),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
