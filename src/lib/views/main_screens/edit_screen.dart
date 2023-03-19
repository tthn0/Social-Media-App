// Dart imports:
import 'dart:io' as io;

// Flutter imports:
import 'package:blog/views/main_screens/tab_bar_screen.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_picker/image_picker.dart' as img_picker;

// Project imports:
import '../../services/cursor.dart';

class EditScreen extends StatefulWidget {
  final Map user;
  final Map post;

  EditScreen(this.user, this.post);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  bool _inProgress = false;

  io.File? _image;
  final picker = img_picker.ImagePicker();

  @override
  initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post['title']);
    _bodyController = TextEditingController(text: widget.post['body']);
  }

  @override
  void dispose() {
    super.dispose();
    this._titleController.dispose();
    this._bodyController.dispose();
  }

  void _handlePublish() async {
    if (this._titleController.text == '' || this._bodyController.text == '') {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Empty Fields'),
          content: Text(
            'Please be sure to title your post and include some body text.',
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }

    setState(() {
      this._inProgress = !this._inProgress;
    });

    print(await Cursor.editPost(
      {
        '_id': widget.post['_id'].toString(),
        'title': this._titleController.text,
        'body': this._bodyController.text,
      },
    ));

    Navigator.pop(context);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TabBarScreen(widget.user, index: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          "Edit post",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: this._titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 120,
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200]!,
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: this._bodyController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Body',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: widget.post['image'] == ''
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(widget.post['image']),
                          ),
                        ),
                ),
                if (_inProgress) ...[
                  SizedBox(height: 12),
                  LinearProgressIndicator(),
                ],
                if (!_inProgress) ...[
                  SizedBox(height: 50 + 12),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _inProgress
          ? null
          : FloatingActionButton.extended(
              backgroundColor: theme.primaryColor,
              onPressed: _handlePublish,
              elevation: 3,
              label: Text(
                '    Save Changes    ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
    );
  }
}
