import 'package:flutter/material.dart';
import 'product.dart';
import 'product_list.dart';

final List<Product> allProduct = ProductList.products;
RangeValues _selectedRange = const RangeValues(100, 500);

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void refresh() {
    setState(() {}); // This will rebuild the widget
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
          child: const Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              '<',
              style: TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(63, 81, 243, 1),
              ),
            ),
          ),
        ),
        title: const Text(
          'Search Product',
          style: TextStyle(
            color: Color.fromRGBO(62, 62, 62, 1),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              MediaQuery.of(context).size.height * 0.3,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            height: 1,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Leather',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // 8px radius
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(217, 217, 217, 1),
                              ),
                            ),

                            suffixIcon: const Icon(
                              Icons.arrow_forward,
                              size: 28,
                              color: Color.fromRGBO(63, 81, 243, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromRGBO(63, 81, 243, 1),
                      ),
                      child: const Icon(Icons.menu, color: Colors.white),
                    ),
                  ],
                ),
                GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: buildGridCard(context),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.32,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const TextField(
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 11,

                      activeTrackColor: const Color.fromRGBO(63, 81, 243, 1),
                      inactiveTrackColor: const Color.fromRGBO(
                        217,
                        217,
                        217,
                        1,
                      ),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 2,
                      ),
                      rangeThumbShape: const RoundRangeSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      thumbColor: const Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      ), // 👈 Thumb color
                      overlayShape: SliderComponentShape
                          .noOverlay, // Removes ripple effect
                      rangeTrackShape:
                          const RectangularRangeSliderTrackShape(), // Straight track
                    ),
                    child: RangeSlider(
                      values: _selectedRange,
                      max: 1000,
                      labels: RangeLabels(
                        _selectedRange.start.round().toString(),
                        _selectedRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _selectedRange = values;
                        });
                      },
                    ),
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                      ),
                      width: double.infinity,
                      height: 60,
                      child: FilledButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            const Color.fromRGBO(63, 81, 243, 1),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // 👈 Radius here
                            ),
                          ),
                        ),
                        child: const Text('APPLY'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
