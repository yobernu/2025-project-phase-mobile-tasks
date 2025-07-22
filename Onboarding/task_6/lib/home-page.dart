import 'package:flutter/material.dart';
import 'details-page.dart';
import 'product.dart';
import 'search-page.dart';

final Product product = Product.product1; 

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Color.fromRGBO(204, 204, 204, 1),
            ),
          ),
          title: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                text: TextSpan(
                  text: "July 14, 2023",
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                    ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                  text: TextSpan(
                    text: "Hello, ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Yohannes",
                        style: TextStyle(fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color.fromRGBO(221, 221, 221, 1)),
              ),
              child: Icon(
                Icons.notifications_none,
                color: Color.fromRGBO(221, 221, 221, 1),
              ),
            ),
          ],
        ),
       body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Products',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color.fromRGBO(221, 221, 221, 1)),
                        ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                        },
                        child: Icon(Icons.search, color: Color.fromRGBO(221, 221, 221, 1),),
                      ),
                    ),
                  ],
                ),
              ),

              // 🧱 Grid View Section
              GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 3 / 2,
                shrinkWrap: true, 
                physics: NeverScrollableScrollPhysics(),
                children: _buildGridCard(context, product,  10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



List<Widget> _buildGridCard(BuildContext context, Product product,  int count) {
  return List.generate(count, (int index) {
    var column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
             onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      imagePath: product.imagePath,
                      title: product.title,
                      price: product.price,
                      subtitle:  product.subtitle,  
                      rating: product.rating,
                      sizes: product.sizes,
                      description: product.description,
                    ),
                  ),
                );
              },
              child: SizedBox(
              height: 165,
              child: Image.asset(
                product.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 8, 26, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                        Spacer(),
                        Text(
                          product.price,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            product.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.star, color: Colors.amber),
                          Text('(${product.rating})', textAlign: TextAlign.end),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Card(

      clipBehavior: Clip.antiAlias, 
      child: column,
      ),
    );
  });
}












