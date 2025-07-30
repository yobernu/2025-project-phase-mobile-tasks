import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'product.dart';
import 'product_manager.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = p.basename(pickedFile.path);
        final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
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

    setState(() => _isLoading = true);
    try {
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: _imageFile!.path,
        title: titleController.text.trim(),
        subtitle: subtitleController.text.trim(),
        price: priceController.text.trim(),
        rating: ratingController.text.trim(),
        sizes: sizeController.text.split(',').map((s) => s.trim()).toList(),
        description: descriptionController.text.trim(),
      );

      final productManager = Provider.of<ProductManager>(context, listen: false);
      productManager.addProduct(newProduct);
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showSnackBar('Error adding product: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          "Add New Product",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF3E3E3E),
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
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
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 190,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 48),
                                  SizedBox(height: 8),
                                  Text("Upload image"),
                                ],
                              )
                            : null,
                      ),
                    ),

                    _buildFormField("Name", titleController),
                    _buildFormField("Category", subtitleController),
                    _buildFormField(
                      "Price",
                      priceController,
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    _buildFormField(
                      "Sizes (comma separated)",
                      sizeController,
                      hint: "39, 40, 41, etc.",
                    ),
                    _buildFormField(
                      "Rating",
                      ratingController,
                      keyboardType: TextInputType.number,
                    ),
                    _buildFormField(
                      "Description",
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "ADD PRODUCT",
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
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
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
            validator: (value) {
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