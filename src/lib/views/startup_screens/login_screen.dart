// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:blog/views/main_screens/tab_bar_screen.dart';
import '../../services/cursor.dart';
import 'functions/functions.dart';
import 'register_screen.dart';
import 'widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(50),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/avatar.png',
                width: 120,
              ),
              SizedBox(height: 10),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 50),
              Input(
                label: 'Username',
                icon: Icons.person,
                controller: _usernameController,
              ),
              SizedBox(height: 15),
              Input(
                label: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                obscure: true,
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  alertBox(
                    context,
                    'Sorry!',
                    'I was too lazy to implement this. Just create a new account lol.',
                  );
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Button(
                label: 'Login',
                theme: theme,
                onPressed: () async {
                  try {
                    Map user = await Cursor.getUser(_usernameController.text);
                    if (user['username'] != _usernameController.text) {
                      throw Exception;
                    } else if (user['password'] != _passwordController.text) {
                      throw Exception;
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => TabBarScreen(user),
                        ),
                      );
                    }
                  } catch (e) {
                    alertBox(
                      context,
                      'Error',
                      'Please make sure you entered the correct credentials.',
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
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
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
