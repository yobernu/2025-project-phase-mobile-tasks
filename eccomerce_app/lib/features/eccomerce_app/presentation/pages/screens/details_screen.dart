import 'dart:io';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

// icon navigator
class _DetailsScreenState extends State<DetailsScreen> {
  int selectedIndex = 0;

  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildImage() {
    final imageUrl = widget.product.imageUrl;

    if (imageUrl.isEmpty) {
      return const Icon(Icons.image, size: 50, color: Colors.grey);
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image, size: 50, color: Colors.grey);
        },
      );
    } else if (imageUrl.startsWith('images/')) {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    } else {
      return Image.file(File(imageUrl), fit: BoxFit.cover);
    }
  }

  Widget _buildSizeSelector() {
    final sizes = widget.product.sizes;

    if (sizes == null || sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size:',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sizes.length,
            itemBuilder: (BuildContext context, int index) {
              final size = sizes[index];
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
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ErrorState) {
          showError(state.message);
        }
      },
      child: Scaffold(
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
                        child: _buildImage(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      key: const Key('back_button'),
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
                              color: Color.fromARGB(255, 47, 11, 187),
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
                            widget.product.subtitle ?? 'No subtitle',
                            style: const TextStyle(
                              letterSpacing: 1.2,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 170, 170, 170),
                            ),
                          ),
                          const Spacer(),
                          if (widget.product.rating != null)
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
                          Flexible(
                            child: Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Color.fromRGBO(62, 62, 62, 1),
                              ),
                            ),
                          ),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSizeSelector(),
                      Text(
                        widget.product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: <Widget>[
                          // DELETE BUTTON
                          TextButton(
                            onPressed: () => _confirmDelete(context),
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
                            onPressed: () => _navigateToUpdate(context),
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
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      context.read<ProductBloc>().add(DeleteProductEvent(widget.product.id));

      if (!mounted) return;
      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Go back
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      showError('Failed to delete: $e');
    }
  }

  Future<void> _navigateToUpdate(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      '/product-updates',
      arguments: widget.product,
    );
    if (mounted) setState(() {}); // Refresh if updated
  }
}
