import 'package:ecommerce_app/features/messaging/presentation/pages/chat/helpers/stories_card.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AllCards allCards = AllCards();
  @override
  void initState() {
    super.initState();
    _navigateToMessafeScreen();
  }

  void _navigateToMessafeScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    if (!mounted) return;
    Navigator.pushNamed(context, '/message-screen');
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      body: Padding(
        padding: EdgeInsets.all(1),
        child: Column(
          // sstories
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [Icon(Icons.search, size: 40, color: Colors.white)],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CustomPaint(
                          size: Size(60, 60),
                          painter: SegmentedCirclePainter(
                            segments: 3,
                            gapDegrees: 26,
                            strokeWidth: 2,
                            color: Colors.orangeAccent,
                          ),
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.asset(
                              "images/avatar.png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("My Status"),
                        ),
                      ],
                    ),

                    allCards.storiesCard(),
                    allCards.storiesCard(),
                    allCards.storiesCard(),
                    allCards.storiesCard(),
                    allCards.storiesCard(),
                    allCards.storiesCard(),
                    allCards.storiesCard(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      
                      allCards.messageCard(context),
                      allCards.messageCard(context),
                      allCards.messageCard(context),
                      allCards.messageCard(context),
                    ],
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