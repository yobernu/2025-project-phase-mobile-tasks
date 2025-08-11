import 'dart:async';
import 'dart:io';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController priceController;
  late TextEditingController sizeController;
  late TextEditingController descriptionController;
  late TextEditingController ratingController;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    subtitleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    ratingController = TextEditingController();
    sizeController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    priceController.dispose();
    sizeController.dispose();
    descriptionController.dispose();
    ratingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = p.basename(pickedFile.path);
        final File savedImage = await File(
          pickedFile.path,
        ).copy('${appDir.path}/$fileName');
        setState(() => _imageFile = savedImage);
      } catch (e) {
        _showSnackBar('Error saving image: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      _showSnackBar('Please select an image');
      return;
    }

    final Product newProduct = Product(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      imageUrl: _imageFile!.path,
      name: titleController.text.trim(),
      subtitle: subtitleController.text.trim().isNotEmpty ? subtitleController.text.trim() : null,
      description: descriptionController.text.trim(),
      price: priceController.text.trim(),
      rating: ratingController.text.trim().isNotEmpty ? ratingController.text.trim() : null,
      sizes: sizeController.text.trim().isNotEmpty
          ? sizeController.text
              .split(',')
              .map((String s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList()
          : null,
    );

    _createProduct(newProduct);
  }

  void _createProduct(Product newProduct) {
    final productBloc = context.read<ProductBloc>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Confirm new Product"),
              content: isLoading
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Creating product...'),
                      ],
                    )
                  : const Text("Are you sure to add this product?"),
              actions: isLoading
                  ? null
                  : [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          final success = await _handleProductCreation(
                            productBloc,
                            newProduct,
                          );
                          if (context.mounted) {
                            if (success) {
                              // Only pop once to close the dialog
                              // The BlocListener will handle the navigation back
                              Navigator.pop(context);
                            } else {
                              setState(() => isLoading = false);
                            }
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Future<bool> _handleProductCreation(
    ProductBloc productBloc,
    Product newProduct,
  ) async {
    try {
      final completer = Completer<bool>();
      final subscription = productBloc.stream.listen((state) {
        if (state is LoadedAllProductsState) {
          completer.complete(true);
        } else if (state is ErrorState) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          completer.complete(false);
        }
      });

      productBloc.add(CreateProductEvent(newProduct));
      final result = await completer.future;
      await subscription.cancel();
      return result;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while creating the product'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ErrorState) {
          _showSnackBar(state.message);
        } else if (state is LoadedAllProductsState) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF3F51F3)),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: const Text(
                'Add New Product',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3E3E3E),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        children: <Widget>[
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 190,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(8),
                                image: _imageFile != null
                                    ? DecorationImage(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _imageFile == null
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.image, size: 48),
                                        SizedBox(height: 8),
                                        Text('Upload image'),
                                      ],
                                    )
                                  : null,
                            ),
                          ),

                          _buildFormField('Name', titleController),
                          _buildFormField('Category', subtitleController),
                          _buildFormField(
                            'Price',
                            priceController,
                            prefixIcon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                          _buildFormField(
                            'Sizes (comma separated)',
                            sizeController,
                            hint: '39, 40, 41, etc.',
                          ),
                          _buildFormField(
                            'Rating',
                            ratingController,
                            keyboardType: TextInputType.number,
                          ),
                          _buildFormField(
                            'Description',
                            descriptionController,
                            maxLines: 5,
                          ),

                          const SizedBox(height: 24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F51F3),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'ADD PRODUCT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}



// navigator