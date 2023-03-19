// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;

// Project imports:
import '../../../services/cursor.dart';
import '../edit_screen.dart';
import '../tab_bar_screen.dart';

class PostCard extends StatelessWidget {
  final Map post;
  final bool isFirst;
  final bool isLast;
  final Map user;

  PostCard(
    this.post, {
    this.isFirst = false,
    this.isLast = false,
    this.user = const {},
  });

  static String convertToAgo(int input) {
    Duration diff = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(input * 1000),
    );

    if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inSeconds >= 15) {
      return '${diff.inSeconds}s ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (this.isFirst) SizedBox(height: 12),
        if (this.post['image'] != '') ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(this.post['image']),
          ),
          SizedBox(height: 20),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: Image.network(
                    this.post['author']['avatar'] != ''
                        ? this.post['author']['avatar']
                        : 'https://i.imgur.com/3EsKsxm.png',
                    width: 40,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.post['author']['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: <Widget>[
                        Text(
                          this.post['author']['username'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "${convertToAgo(this.post['date'])}",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (this.user.keys.toList().isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Action'),
                        content: Text('What would you like to do?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditScreen(
                                    this.user,
                                    this.post,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () async {
                              print(
                                await Cursor.deletePost(this.post['_id']),
                              );
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => TabBarScreen(
                                    this.user,
                                    index: 1,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        elevation: 5,
                      );
                    },
                  );
                }
              },
              child: Icon(
                Icons.more_horiz,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          this.post['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        Text(
          this.post['body'],
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            fa.FaIcon(
              fa.FontAwesomeIcons.solidHeart,
              color: Colors.grey[400],
              // color: Colors.pinkAccent,
              size: 14,
            ),
            SizedBox(width: 10),
            Text(
              '0',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(width: 25),
            Icon(
              Icons.mode_comment,
              color: Colors.grey[400],
              size: 14,
            ),
            SizedBox(width: 10),
            Text(
              '0',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        if (isLast) SizedBox(height: 12),
      ],
    );
  }
}
