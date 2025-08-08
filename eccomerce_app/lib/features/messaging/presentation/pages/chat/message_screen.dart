import 'package:ecommerce_app/features/messaging/presentation/pages/chat/helpers/stories_card.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allCards = AllCards();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -15),
                      child: allCards.card(),
                    ),

                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Sabila Sayma",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('8 members, 5 online'),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: const [
                        Icon(Icons.call_outlined),
                        SizedBox(width: 18),
                        Icon(Icons.video_call),
                      ],
                    ),
                  ],
                ),
              ),

              // Right chatter
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: SingleChildScrollView(
                    child: Column(children: [chatCard()]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final allCards = AllCards();
chatCard() {
  return Column(
    // color: Colors.amber,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          allCards.card(),
          SizedBox(width: 12),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("Annei Ellison"),
          ),
        ],
      ),


      // others message
      Text("This is my new 3rd design"),

    ],
    
  );
}
