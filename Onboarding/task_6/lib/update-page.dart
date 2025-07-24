import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'product.dart';

var allProducts = ProductList.products;

class UpdatePage extends StatefulWidget {
  final String id;
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

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController desciptionController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    subtitleController.text = widget.subtitle;
    priceController.text = widget.price;
    desciptionController.text = widget.description;
    ratingController.text = widget.rating;
    sizeController.text = widget.sizes.join(', ');
    _imageFile = File(widget.imagePath);
  }


  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(pickedFile.path);
    final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

    setState(() {
      _imageFile = savedImage;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "<",
              style: TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(63, 81, 243, 1),
              ),
            ),
          ),
        ),

        title: Text(
          "Add Product",
          style: TextStyle(
            color: Color.fromRGBO(62, 62, 62, 1),
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 190,
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Color.fromRGBO(243, 243, 243, 1),
                child: Center(
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 48,
                              width: 48,
                              child: Image.asset("images/upload.png"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Text("Upload image"),
                            ),
                          ],
                        )
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
            ),

            CustomCard(
              title: "name",
              height: 50,
              textController: titleController,
            ),
            CustomCard(
              title: "Category",
              height: 50,
              textController: subtitleController,
            ),
            CustomCard(
              title: "Price",
              icon: Icons.attach_money,
              height: 50,
              textController: priceController,
            ),
            CustomCard(
              title: "description",
              height: 150,
              textController: desciptionController,
            ),

            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(63, 81, 243, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ADD", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: TextButton(
                onPressed: () {
                  // your action
                },
                style: TextButton.styleFrom(
                  // backgroundColor: Color.fromRGBO(167, 38, 38, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: Color.fromRGBO(255, 19, 19, 0.79),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _submitForm(context);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Color.fromARGB(255, 72, 10, 10),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(context) {
    final title = titleController.text;
    final subtitle = subtitleController.text;
    final description = desciptionController.text;
    final price = priceController.text;

    if (title.isEmpty ||
        subtitle.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        _imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please complete all fields')));
      return;
    }

    // print("Name: $name, Age: $age, Image: ${_imageFile!.path}");
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double height;
  final TextEditingController textController;

  const CustomCard({
    super.key,
    required this.title,
    this.icon,
    required this.height,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(title, style: TextStyle(fontSize: 16)),
        ),
        Container(
          height: height,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromRGBO(243, 243, 243, 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              if (icon != null) Icon(icon),
            ],
          ),
        ),
      ],
    );
  }
}
