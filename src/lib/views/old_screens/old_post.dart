// Flutter imports:
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Map post;

  PostCard(this.post);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              "By: ${post['author']}",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Divider(height: 30),
            Text(
              post['title'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              post['body'],
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.25,
              ),
            ),
            if (post['image'] != '') ...[
              SizedBox(height: 15),
              Image.network(
                post['image'],
              ),
            ],
            Divider(height: 40),
            Text(
              "${post['date']}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
