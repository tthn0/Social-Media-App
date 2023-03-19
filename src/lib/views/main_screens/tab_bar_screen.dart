// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;

// Project imports:
import 'home_screen.dart';
import 'post_screen.dart';
import 'profile_screen.dart';

class TabBarScreen extends StatefulWidget {
  final Map user;
  final int index;

  const TabBarScreen(this.user, {this.index = 0});

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  List<Widget> pageList = <Widget>[];
  int _currentIndex = 0;

  @override
  void initState() {
    pageList.addAll([
      HomeScreen(widget.user),
      ProfileScreen(widget.user),
    ]);
    this._currentIndex = widget.index;
    super.initState();
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: IndexedStack(
        index: _currentIndex,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[400],
        selectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        onTap: _changeTab,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Post something!',
        child: fa.FaIcon(fa.FontAwesomeIcons.featherAlt),
        elevation: 3,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostScreen(widget.user),
            ),
          ).then((userPosted) {
            if (userPosted != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => TabBarScreen(widget.user, index: 0),
                ),
              );
            }
          });
        },
      ),
    );
  }
}
