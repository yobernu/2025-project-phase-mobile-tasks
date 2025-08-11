import 'package:flutter/material.dart';
import '../../../../auth/domain/entities/auth.dart';

class CardData {
  final String id;
  final String name;
  final String image;
  final bool hasStory;
  final String? email;

  CardData({
    required this.id,
    required this.name,
    required this.image,
    this.hasStory = false,
    this.email,
  });

  // Factory constructor to create CardData from User entity
  factory CardData.fromUser(User user, {bool hasStory = false}) {
    return CardData(
      id: user.id,
      name: user.name,
      image:
          "images/avatar.png", // Default avatar, can be updated when user profile pics are added
      hasStory: hasStory,
      email: user.email,
    );
  }
}

class AllCards {
  // Static fallback data for when no users are loaded
  List<CardData> get _fallbackCards => [
    CardData(
      id: "1",
      name: "Alexa",
      image: "images/avatar.png",
      hasStory: true,
    ),
    CardData(
      id: "2",
      name: "Sarah",
      image: "images/avatar.png",
      hasStory: true,
    ),
    CardData(
      id: "3",
      name: "Mike",
      image: "images/avatar.png",
      hasStory: false,
    ),
    CardData(id: "4", name: "Emma", image: "images/avatar.png", hasStory: true),
    CardData(
      id: "5",
      name: "John",
      image: "images/avatar.png",
      hasStory: false,
    ),
    CardData(id: "6", name: "Lisa", image: "images/avatar.png", hasStory: true),
  ];

  // Dynamic cards from actual users - will be set from outside
  List<CardData> _dynamicCards = [];

  List<CardData> get cards =>
      _dynamicCards.isNotEmpty ? _dynamicCards : _fallbackCards;

  // Method to update cards with real user data
  void updateCards(List<User> users) {
    _dynamicCards = users
        .map((user) => CardData.fromUser(user, hasStory: true))
        .toList();
  }

  // Method to add a single user
  void addUser(User user) {
    final cardData = CardData.fromUser(user, hasStory: true);
    _dynamicCards.add(cardData);
  }

  // Method to clear dynamic cards
  void clearCards() {
    _dynamicCards.clear();
  }

  Widget storiesCard(CardData cardData, {bool useSegments = false}) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 9),
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildCardWithData(cardData),
              // Ring — either full or segmented
              CustomPaint(
                size: Size(60, 60),
                painter: useSegments
                    ? SegmentedCirclePainter(
                        segments: 3,
                        gapDegrees: 12,
                        strokeWidth: 5,
                        color: const Color.fromARGB(255, 39, 32, 35),
                      )
                    : FullCirclePainter(),
              ),
            ],
          ),
        ),

        Text(cardData.name, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget messageCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, 'message-screen'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildCard(),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Alex Linderson",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "How are you today?",
                    style: TextStyle(color: Color.fromARGB(179, 57, 47, 47)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "2 min ago",
                  style: TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
                ),
                SizedBox(height: 6),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 60, 9, 143),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard() {
    return // Circular Card with image
    Card(
      shape: CircleBorder(),
      color: const Color.fromARGB(255, 183, 184, 183),
      elevation: 4,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: ClipOval(
          child: Image.asset(
            "images/avatar.png",
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildCardWithData(CardData cardData) {
    return // Circular Card with image
    Card(
      shape: CircleBorder(),
      color: const Color.fromARGB(255, 183, 184, 183),
      elevation: 4,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: ClipOval(
          child: Image.asset(
            cardData.image,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FullCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromRGBO(33, 150, 243, 1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - 6,
    );

    // Draw full 360° circle
    canvas.drawArc(rect, 0, 2 * 3.1415926, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SegmentedCirclePainter extends CustomPainter {
  final int segments;
  final double gapDegrees;
  final double strokeWidth;
  final Color color;

  SegmentedCirclePainter({
    required this.segments,
    required this.gapDegrees,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = (size.width / 2) - strokeWidth;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final double totalGap = gapDegrees * segments;
    final double sweep = (360 - totalGap) / segments;
    double startAngle = -90 * 3.1415926 / 180; // Start at top (12 o'clock)

    for (int i = 0; i < segments; i++) {
      canvas.drawArc(rect, startAngle, sweep * 3.1415926 / 180, false, paint);
      startAngle += (sweep + gapDegrees) * 3.1415926 / 180;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
