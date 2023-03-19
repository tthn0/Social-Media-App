// Dart imports:
import 'dart:convert' as convert;
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;
import 'package:image_picker/image_picker.dart' as img_picker;
import 'package:intl/intl.dart' as intl;

// Project imports:
import '../../services/cursor.dart';
import 'old_post.dart';

class OldHomeScreen extends StatefulWidget {
  @override
  _OldHomeScreenState createState() => _OldHomeScreenState();
}

class _OldHomeScreenState extends State<OldHomeScreen> {
  Map _userData = {'name': 'Guest User'};
  List _posts = [];

  void refreshPosts() async {
    _posts = await Cursor.getPosts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () async {
            _userData = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MenuScreen(userData: _userData),
              ),
            );
            print(_userData);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              print('Plus');
            },
          ),
        ],
        title: Text(
          'Latest Posts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: RefreshIndicator(
            onRefresh: () async {
              refreshPosts();
              // return Future.delayed(Duration(seconds: 1), () {
              //   setState(() {
              //     print('Refreshed');
              //   });
              // });
            },
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 12),
              itemCount: _posts.length,
              itemBuilder: (BuildContext _context, int i) {
                return PostCard(
                  _posts[_posts.length - 1 - i],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostScreen(_userData),
            ),
          ).then((value) {
            refreshPosts();
          });
        },
        tooltip: 'Refresh',
        backgroundColor: theme.primaryColor,
        child: fa.FaIcon(fa.FontAwesomeIcons.featherAlt),
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  final Map userData;

  MenuScreen({
    required this.userData,
  });

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController _controller1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller1.text = widget.userData['name'];
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, {'name': 'Guest User'});
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: TextField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _controller1.text,
                  });
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostScreen extends StatefulWidget {
  final Map userData;

  PostScreen(this.userData);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  io.File? _image;
  final picker = img_picker.ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: img_picker.ImageSource.gallery);
    setState(() {
      if (pickedFile != null)
        _image = io.File(pickedFile.path);
      else
        print('No image selected.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          "What's on your mind?",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: TextField(
                    controller: _controller1,
                    decoration: InputDecoration(
                      labelText: 'Title your post',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 200,
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: TextField(
                      controller: _controller2,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Add body text',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: _image == null
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Image.file(_image!),
                        ),
                ),
                TextButton(
                  onPressed: getImage,
                  child: Text(_image == null ? 'Add Image' : 'Change Image'),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () async {
          if (_controller1.text == '' || _controller2.text == '') {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Empty Fields'),
                content: Text(
                  'Please be sure to title your post and include some body text.',
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          }

          String base64Str = '';

          if (_image != null) {
            base64Str = convert.base64Encode(
              _image!.readAsBytesSync(),
            );
          }

          print(await Cursor.publishPost(
            {
              'title': _controller1.text,
              'body': _controller2.text,
              'image': base64Str,
              'date': intl.DateFormat.Hm().add_MMMMd().format(DateTime.now()),
              'author': widget.userData['name'],
            },
          ));

          Navigator.pop(context);
        },
        elevation: 0,
        label: Text(
          '       Publish       ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
