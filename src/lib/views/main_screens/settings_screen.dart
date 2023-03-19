// Dart imports:
import 'dart:convert' as convert;
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_cropper/image_cropper.dart' as img_cropper;
import 'package:image_picker/image_picker.dart' as img_picker;

// Project imports:
import '../../services/cursor.dart';
import '../startup_screens/login_screen.dart';
import '../startup_screens/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  final Map user;

  SettingsScreen(this.user);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  bool _inProgress = false;

  io.File? _image;
  final picker = img_picker.ImagePicker();

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name']);
    _usernameController = TextEditingController(text: widget.user['username']);
    _emailController = TextEditingController(text: widget.user['email']);
    _passwordController = TextEditingController(text: widget.user['password']);
    _bioController = TextEditingController(text: widget.user['bio']);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
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

    if (pickedFile != null) {
      _image = io.File(pickedFile.path);

      io.File? cropped = await img_cropper.ImageCropper.cropImage(
        sourcePath: _image!.path,
        aspectRatio: img_cropper.CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      setState(() {
        _image = cropped ?? _image;
      });
    }
  }

  void _handleChanges() async {
    if (this._nameController.text == '' ||
        this._usernameController.text == '' ||
        this._emailController.text == '' ||
        this._passwordController.text == '') {
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

    String base64Str = widget.user['avatar'];

    if (_image != null)
      base64Str = convert.base64Encode(
        _image!.readAsBytesSync(),
      );

    setState(() {
      this._inProgress = !this._inProgress;
    });

    Map newUser = await Cursor.updateUser({
      '_id': widget.user['_id'].toString(),
      'name': this._nameController.text,
      'username': this._usernameController.text,
      'email': this._emailController.text,
      'password': this._passwordController.text,
      'bio': this._bioController.text,
      'avatar': base64Str,
    });

    print(newUser);

    Navigator.pop(context, newUser);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          "Edit Profile",
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
                SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(1000)),
                  child: _image != null
                      ? Image.file(_image!, width: 200)
                      : Image.network(
                          widget.user['avatar'] != ''
                              ? widget.user['avatar']
                              : 'https://i.imgur.com/3EsKsxm.png',
                          width: 200,
                        ),
                ),
                SizedBox(height: 40),
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
                SizedBox(height: 40),
                Input(
                  label: 'Full Name',
                  controller: _nameController,
                  icon: Icons.face,
                ),
                SizedBox(height: 12),
                Input(
                  label: 'Username',
                  controller: _usernameController,
                  icon: Icons.person,
                ),
                SizedBox(height: 12),
                Input(
                  label: 'Email',
                  controller: _emailController,
                  icon: Icons.email,
                ),
                SizedBox(height: 12),
                Input(
                  label: 'Password',
                  controller: _passwordController,
                  icon: Icons.person,
                  obscure: true,
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
                      controller: this._bioController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Bio',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_inProgress) ...[
                  SizedBox(height: 40),
                  LinearProgressIndicator(),
                ],
                if (!_inProgress) ...[
                  SizedBox(height: 90),
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
              onPressed: _handleChanges,
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
