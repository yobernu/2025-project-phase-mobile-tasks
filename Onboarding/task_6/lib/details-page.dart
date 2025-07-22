import 'package:flutter/material.dart';
import 'update-page.dart';

class DetailsPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final List<String> sizes;
  final String description;

  const DetailsPage({
    super.key,
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.topLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 24),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white, // 🟡 background color
                    shape: BoxShape.circle, // 🎯 makes it perfectly round
                  ),
                  child: Center(
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
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: widget.subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 170, 170, 170),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 255, 215, 1),
                        ),
                        Text(
                          "(${widget.rating})",
                          style: TextStyle(fontFamily: 'Sora'),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12),

                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Color.fromRGBO(62, 62, 62, 1),
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.price,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Row(
                    children: [
                      Text(
                        "Size: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.sizes.length,
                    itemBuilder: (context, index) {
                      final pro = widget.sizes[index];
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          width: 60,
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected ? Color.fromRGBO(63, 81, 243, 1) : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              pro,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(widget.description),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 24, left: 24),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 44, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    side: BorderSide(
                      color: Color.fromRGBO(255, 19, 19, 0.79),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "DELETE",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color.fromRGBO(255, 19, 19, 0.79),
                    ),
                  ),
                ),

                Spacer(),

                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(63, 81, 243, 1),
                    padding: EdgeInsets.symmetric(horizontal: 44, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdatePage()),
                      );
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color.fromRGBO(255, 255, 255, 0.79),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
