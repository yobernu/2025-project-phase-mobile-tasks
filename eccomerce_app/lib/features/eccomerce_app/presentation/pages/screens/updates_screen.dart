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

class UpdatesScreen extends StatefulWidget {
  final Product product;
  const UpdatesScreen({super.key, required this.product});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
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
    titleController = TextEditingController(text: widget.product.name);
    subtitleController = TextEditingController(text: widget.product.subtitle);
    priceController = TextEditingController(text: widget.product.price.toString());
    descriptionController = TextEditingController(text: widget.product.description);
    ratingController = TextEditingController(text: widget.product.rating);
    sizeController = TextEditingController(
      text: widget.product.sizes?.join(', ') ?? ''
    );
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
        setState(() {
          _imageFile = savedImage;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnackBar('Error saving image: $e');
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedProduct = Product(
        id: widget.product.id,
        imageUrl: _imageFile?.path ?? widget.product.imageUrl,
        name: titleController.text.trim(),
        subtitle: subtitleController.text.trim(),
        price: double.tryParse(priceController.text.trim()) ?? 0.0,
        rating: ratingController.text.trim(),
        sizes: sizeController.text.isNotEmpty
            ? sizeController.text.split(',').map((s) => s.trim()).toList()
            : [],
        description: descriptionController.text.trim(),
      );

      context.read<ProductBloc>().add(UpdateProductEvent(updatedProduct));
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error updating product: $e');
    }
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      context.read<ProductBloc>().add(DeleteProductEvent(widget.product.id));
      if (!mounted) return;
      
      Navigator.pop(context); // Close loading
      Navigator.pop(context); // Go back
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      _showSnackBar('Failed to delete product: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildImageWidget() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(_imageFile!, fit: BoxFit.cover),
      );
    }

    if (widget.product.imageUrl.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 48),
          SizedBox(height: 8),
          Text('Upload image'),
        ],
      );
    }

    if (widget.product.imageUrl.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.product.imageUrl,
          fit: BoxFit.cover,
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
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(height: 8),
                Text('Failed to load image'),
              ],
            );
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(File(widget.product.imageUrl), fit: BoxFit.cover),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? hint,
    int maxLines = 1,
    bool isPrice = false,
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
              if (isPrice && double.tryParse(value.trim()) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ErrorState) {
          if (mounted) {
            _showSnackBar(state.message);
            setState(() => _isLoading = false);
          }
        } else if (state is ProductUpdatedState) {
          if (mounted) {
            Navigator.pop(context);
            _showSnackBar('Product updated successfully');
          }
        }
      },
      child: Scaffold(
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
                          ),
                          child: _buildImageWidget(),
                        ),
                      ),
                      _buildFormField('Name', titleController),
                      _buildFormField('Category', subtitleController),
                      _buildFormField(
                        'Price',
                        priceController,
                        prefixIcon: Icons.attach_money,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        isPrice: true,
                      ),
                      _buildFormField(
                        'Sizes (comma separated)',
                        sizeController,
                        hint: '39, 40, 41, etc.',
                      ),
                      _buildFormField(
                        'Rating',
                        ratingController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            side: const BorderSide(color: Colors.red),
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
      ),
    );
  }
}