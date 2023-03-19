// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:blog/views/startup_screens/functions/functions.dart';
import '../../services/cursor.dart';
import 'widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.backgroundColor,
        leading: BackButton(
          color: theme.primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(50),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "We're glad you're here",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 50),
              Input(
                label: 'Full Name',
                icon: Icons.face,
                controller: _nameController,
              ),
              SizedBox(height: 15),
              Input(
                label: 'Username',
                icon: Icons.person,
                controller: _usernameController,
              ),
              SizedBox(height: 15),
              Input(
                label: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              SizedBox(height: 15),
              Input(
                label: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                obscure: true,
              ),
              SizedBox(height: 50),
              Button(
                label: 'Register',
                theme: theme,
                onPressed: () async {
                  try {
                    Map insertedUser = await Cursor.insertUser(
                      _nameController.text,
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );

                    alertBox(
                      context,
                      'Success',
                      'Your account has been created! Please sign in.',
                      action: () {
                        Navigator.pop(context);
                      },
                    );
                  } catch (e) {
                    alertBox(
                      context,
                      'Error',
                      'There was an error registering your account. Please try again later.',
                    );
                  }
                },
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
