import 'dart:async';
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
        debugPrint('🔄 ProductBloc state changed: ${state.runtimeType}');

        if (state is ErrorState) {
          debugPrint('❌ ErrorState: ${state.message}');
          showError(state.message);
        } else if (state is LoadedAllProductsState) {
          debugPrint('✅ Product deleted successfully. Navigating back...');
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to previous screen
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
                      height: 360,
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
                  padding: const EdgeInsets.fromLTRB(36, 24, 36, 24),
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
                          // if (widget.product.rating != null)
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 255, 215, 1),
                                size: 20,
                              ),
                              // widget.product.rating.toString() ??
                              const Text('4.0'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          const Spacer(),
                          Text(
                            '\$${widget.product.price.toString()}',
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

  Future<bool> _confirmDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Product'),
              content: const Text('Are you sure you want to delete this product?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('DELETE'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _handleProductDeletion(ProductBloc productBloc, String productId) async {
    final completer = Completer<bool>();
    late final StreamSubscription subscription;

    subscription = productBloc.stream.listen((state) {
      if (state is LoadedAllProductsState) {
        if (!completer.isCompleted) {
          subscription.cancel();
          completer.complete(true);
        }
      } else if (state is ErrorState) {
        if (!completer.isCompleted) {
          subscription.cancel();
          completer.complete(false);
        }
      }
    });

    // Start the delete operation
    productBloc.add(DeleteProductEvent(productId));

    return completer.future;
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await _confirmDeleteDialog();
    if (!shouldDelete || !mounted) return;

    final productBloc = context.read<ProductBloc>();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final success = await _handleProductDeletion(productBloc, widget.product.id);
      
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        if (mounted) {
          Navigator.pop(context); // Go back to previous screen
        }
      } else {
        showError('Failed to delete product');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        showError('An error occurred: $e');
      }
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
// Bloclistener