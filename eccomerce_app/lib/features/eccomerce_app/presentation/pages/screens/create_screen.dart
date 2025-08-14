import 'dart:io';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/helpers/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';

class CreateScreen extends StatefulWidget {
  final ImagePickerService imagePickerService;

  const CreateScreen({super.key, required this.imagePickerService});

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

  // addProductButton
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
    setState(() => _isLoading = true);
    try {
      final image = await widget.imagePickerService.pickAndSaveImage();
      if (image != null) {
        setState(() => _imageFile = image);
      }
    } catch (e) {
      _showSnackBar('Error saving image: $e');
    } finally {
      setState(() => _isLoading = false);
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
      subtitle: subtitleController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      rating: ratingController.text.trim(),
      sizes: sizeController.text
          .split(',')
          .map((String s) => s.trim())
          .toList(),
    );

    _createProduct(newProduct);
  }

  void _createProduct(Product newProduct) {
    final productBloc = context.read<ProductBloc>();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Confirm new Product"),
        content: const Text("Are you sure to add this product?"),
        actions: <Widget>[
          TextButton(
            key: const Key('cancelButton'),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            key: const Key('addButton'),
            onPressed: () {
              productBloc.add(CreateProductEvent(newProduct));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Add", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
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
                            key: const Key('productImageField'),
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

                          _buildFormField(
                            'Name',
                            titleController,
                            key: const Key('productNameField'),
                          ),
                          _buildFormField(
                            'Price',
                            priceController,
                            prefixIcon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            key: const Key('productPriceField'),
                          ),
                          _buildFormField(
                            'Sizes (comma separated)',
                            sizeController,
                            hint: '39, 40, 41, etc.',
                            key: const Key('productSizeField'),
                          ),
                          _buildFormField(
                            'Description',
                            descriptionController,
                            maxLines: 5,
                            key: const Key('productDescriptionField'),
                          ),

                          const SizedBox(height: 24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              key: const Key('addProductsButton'),
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
    Key? key,
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
            key: key,
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
