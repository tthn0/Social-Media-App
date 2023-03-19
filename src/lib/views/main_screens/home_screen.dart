// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../services/cursor.dart';
import 'widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final Map user;

  const HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _posts = [];

  void _refreshPosts() async {
    _posts = await Cursor.getPosts();
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
              Icons.panorama,
              color: Colors.black,
            ),
            SizedBox(width: 10),
            Text(
              'Latest Posts',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RefreshIndicator(
            onRefresh: () async => _refreshPosts(),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 50),
              itemCount: _posts.length,
              itemBuilder: (BuildContext _context, int i) {
                if (i == 0) {
                  return PostCard(
                    _posts[_posts.length - 1 - i],
                    isFirst: true,
                  );
                } else if (i == _posts.length - 1) {
                  return PostCard(
                    _posts[_posts.length - 1 - i],
                    isLast: true,
                  );
                } else {
                  return PostCard(
                    _posts[_posts.length - 1 - i],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
