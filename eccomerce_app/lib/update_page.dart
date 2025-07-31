import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'product_manager.dart';

class UpdatePage extends StatefulWidget {
  final int id;
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final List<String> sizes;
  final String description;

  const UpdatePage({
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
  State<UpdatePage> createState() => _UpdatePageState();
}
// navigator
class _UpdatePageState extends State<UpdatePage> {
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
    titleController = TextEditingController(text: widget.title);
    subtitleController = TextEditingController(text: widget.subtitle);
    priceController = TextEditingController(text: widget.price);
    descriptionController = TextEditingController(text: widget.description);
    ratingController = TextEditingController(text: widget.rating);
    sizeController = TextEditingController(text: widget.sizes.join(', '));
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
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = p.basename(pickedFile.path);
        final File savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
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

    setState(() => _isLoading = true);
    try {
      final Product updatedProduct = Product(
        id: widget.id,
        imagePath: _imageFile?.path ?? widget.imagePath,
        title: titleController.text.trim(),
        subtitle: subtitleController.text.trim(),
        price: priceController.text.trim(),
        rating: ratingController.text.trim(),
        sizes: sizeController.text.split(',').map((String s) => s.trim()).toList(),
        description: descriptionController.text.trim(),
      );

      final ProductManager productManager = Provider.of<ProductManager>(context, listen: false);
      productManager.updateProduct(updatedProduct);
      
      if (mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {
      _showSnackBar('Error updating product: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              setState(() => _isLoading = true);
              try {
                final ProductManager productManager = Provider.of<ProductManager>(
                  context, 
                  listen: false
                );
                productManager.deleteProduct(widget.id.toString());
                if (mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
              } catch (e) {
                _showSnackBar('Error deleting product: $e');
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
          'Update Product',
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(8),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(_imageFile!),
                                  fit: BoxFit.cover,
                                )
                              : widget.imagePath.isNotEmpty
                                  ? DecorationImage(
                                      image: widget.imagePath.startsWith('assets/')
                                          ? AssetImage(widget.imagePath)
                                          : FileImage(File(widget.imagePath)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: _imageFile == null && widget.imagePath.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'SAVE CHANGES',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      child: OutlinedButton(
                        onPressed: _deleteProduct,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'DELETE PRODUCT',
                          style: TextStyle(
                            color: Colors.red,
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
        children: <Widget>[
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