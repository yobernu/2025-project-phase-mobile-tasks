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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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
                        child: widget.product.imagePath.startsWith('http')
                            ? Image.network(
                                widget.product.imagePath,
                                // fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  );
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
                            widget.product.subtitle,
                            style: const TextStyle(
                              letterSpacing: 1.2,
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
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              widget.product.title,
                              // maxLines: 2,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Color.fromRGBO(62, 62, 62, 1),
                              ),
                            ),
                          ),

                          Text(
                            '\$${widget.product.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      widget.product.sizes.isNotEmpty
                          ? Row(
                              children: <Widget>[
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          final String size =
                                              widget.product.sizes[index];
                                          final bool isSelected =
                                              selectedIndex == index;

                                          return GestureDetector(
                                            onTap: () => setState(
                                              () => selectedIndex = index,
                                            ),
                                            child: Container(
                                              width: 60,
                                              margin: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: isSelected
                                                    ? const Color.fromRGBO(
                                                        63,
                                                        81,
                                                        243,
                                                        1,
                                                      )
                                                    : Colors.white,
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                    30,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
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
                              ],
                            )
                          : const SizedBox.shrink(),
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
                            onPressed: () async {
                              // Show confirmation dialog
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Product'),
                                  content: const Text(
                                    'Are you sure you want to delete this product?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (shouldDelete != true) return;
                              //  if (!mounted) return;
                              // Show loading dialog
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                              try {
                                // Dispatch delete event to bloc
                                context.read<ProductBloc>().add(
                                  DeleteProductEvent(
                                    widget.product.id.toString(),
                                  ),
                                );

                                if (!mounted) return;

                                // Close loading dialog
                                Navigator.pop(context);

                                // Show success message and navigate back
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Product deleted successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.pop(
                                  context,
                                ); // Go back to previous screen
                              } catch (e) {
                                if (!mounted) return;
                                Navigator.pop(context); // Close loading dialog
                                showError('An error occurred: $e');
                              }
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
                            onPressed: () async{
                              await Navigator.pushNamed(
                                context,
                                '/product-updates',
                                arguments: widget.product,
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
}
