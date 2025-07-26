import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_6/product_manager.dart';

class DetailsPage extends StatefulWidget {
  final String id;
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final List<String> sizes;
  final String description;

  const DetailsPage({
    super.key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.sizes,
    required this.description,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: widget.imagePath.startsWith('images/')
                          ? Image.asset(widget.imagePath, fit: BoxFit.cover)
                          : Image.file(File(widget.imagePath), fit: BoxFit.cover),
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
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 170, 170, 170),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 215, 1),
                              size: 20,
                            ),
                            Text("(${widget.rating})"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Color.fromRGBO(62, 62, 62, 1),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Size:",
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
                        itemCount: widget.sizes.length,
                        itemBuilder: (context, index) {
                          final size = widget.sizes[index];
                          final isSelected = selectedIndex == index;

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
                      widget.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // DELETE BUTTON
                        TextButton(
                          onPressed: () {
                            final productManager = Provider.of<ProductManager>(
                              context, 
                              listen: false
                            );
                            productManager.deleteProduct(widget.id);
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
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            "DELETE",
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
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/update',
                              arguments: {
                                'id': widget.id,
                                'imagePath': widget.imagePath,
                                'title': widget.title,
                                'price': widget.price,
                                'subtitle': widget.subtitle,
                                'rating': widget.rating,
                                'sizes': widget.sizes,
                                'description': widget.description,
                              },
                            );
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
                            "UPDATE",
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





