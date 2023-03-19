// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../services/cursor.dart';
import 'settings_screen.dart';
import 'tab_bar_screen.dart';
import 'widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final Map user;

  const ProfileScreen(this.user);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List _posts = [];

  void _refreshPosts() async {
    _posts = await Cursor.getPosts(authorId: widget.user['_id']);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        title: Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.black,
            ),
            SizedBox(width: 10),
            Text(
              widget.user['username'],
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(widget.user),
                ),
              ).then((newUser) async {
                if (newUser != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TabBarScreen(newUser, index: 1),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RefreshIndicator(
            onRefresh: () async => _refreshPosts(),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Followers',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Image.network(
                        widget.user['avatar'] != ''
                            ? widget.user['avatar']
                            : 'https://i.imgur.com/3EsKsxm.png',
                        width: 100,
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Following',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.user['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.user['bio'] != '') ...[
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      widget.user['bio'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                Divider(
                  height: 50,
                  thickness: 1.5,
                ),
                if (_posts.length == 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      Image.asset(
                        'assets/empty.png',
                        width: MediaQuery.of(context).size.width * .666,
                      ),
                      SizedBox(height: 25),
                      Text(
                        "It sure looks empty here. Post something!",
                      ),
                    ],
                  ),
                for (int i = _posts.length - 1; i >= 0; i--) ...[
                  if (i != 0) ...[
                    PostCard(_posts[i], user: widget.user),
                    Divider(height: 50),
                  ] else ...[
                    PostCard(_posts[i], user: widget.user),
                    SizedBox(height: 12),
                  ]
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
