import 'package:flutter/material.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

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
            Container(
              height: 190,
              margin: EdgeInsets.only(left: 16, right: 16),
              color: Color.fromRGBO(243, 243, 243, 1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: Image.asset("images/upload.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text("upload image"),
                    ),
                  ],
                ),
              ),
            ),
            CustomCard(title: "name", height: 50),
            CustomCard(title: "Category", height: 50),
            CustomCard(title: "Price", icon: Icons.attach_money, height: 50),
            CustomCard(title: "description", height: 150),

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
                      Text("Delete", style: TextStyle(color: Colors.white)),
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
          ],
        ),
      ),
    );
  }
}





class CustomCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double height;

  const CustomCard({
    super.key,
    required this.title,
    this.icon,
    required this.height,
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
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