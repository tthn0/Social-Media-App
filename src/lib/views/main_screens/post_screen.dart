// Dart imports:
import 'dart:convert' as convert;
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_picker/image_picker.dart' as img_picker;

// Project imports:
import '../../services/cursor.dart';

class PostScreen extends StatefulWidget {
  final Map user;

  PostScreen(this.user);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  bool _inProgress = false;

  io.File? _image;
  final picker = img_picker.ImagePicker();

  @override
  void dispose() {
    super.dispose();
    this._titleController.dispose();
    this._bodyController.dispose();
  }

  void _getImageFromCamera() {
    getImage(fromGallery: false);
  }

  void _getImageFromGallery() {
    getImage(fromGallery: true);
  }

  Future getImage({bool fromGallery = false}) async {
    final pickedFile = await picker.getImage(
      source: fromGallery
          ? img_picker.ImageSource.gallery
          : img_picker.ImageSource.camera,
    );
    setState(() {
      if (pickedFile != null)
        _image = io.File(pickedFile.path);
      else
        print('No image selected.');
    });
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

    String base64Str = '';

    if (_image != null)
      base64Str = convert.base64Encode(
        _image!.readAsBytesSync(),
      );

    setState(() {
      this._inProgress = !this._inProgress;
    });

    print(await Cursor.publishPost(
      {
        'title': this._titleController.text,
        'body': this._bodyController.text,
        'image': base64Str,
        'author_id': widget.user['_id'].toString(),
      },
    ));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
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
                      labelText: 'Title your post',
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
                        labelText: 'Add body text',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: _image == null
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
                            child: Image.file(_image!),
                          ),
                        ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(250, 71, 129, 1),
                            Color.fromRGBO(248, 138, 14, 1),
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color.fromRGBO(248, 138, 14, 1).withOpacity(.3),
                            blurRadius: 5.0,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: TextButton(
                        onPressed: _getImageFromGallery,
                        child: Row(
                          children: [
                            Icon(
                              Icons.collections,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              _image == null ? 'Open gallery' : 'Change Image',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(49, 128, 230, 1),
                            Color.fromRGBO(58, 200, 242, 1),
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color.fromRGBO(58, 200, 242, 1).withOpacity(.3),
                            blurRadius: 5.0,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: TextButton(
                        onPressed: _getImageFromCamera,
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              _image == null ? 'Open camera' : 'Change Image',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
