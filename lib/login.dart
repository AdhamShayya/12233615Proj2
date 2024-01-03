import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 350.0,
          child: Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          handleLogin(context);
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Sign up here',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://12233615.000webhostapp.com/login.php'),
        // Replace with your server URL
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Parse the user ID and name from the response
        List<String> userData = response.body.split('|');
        if (userData.length == 2) {
          int userId = int.tryParse(userData[0]) ?? -1;
          String userName = userData[1];
          if (userId != -1) {
            // User logged in successfully
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login successful'),
              ),
            );

            // Navigate to the home screen with the user ID and name
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Home(userId: userId, userName: userName),
              ),
            );
          } else {
            // Invalid user ID from the server
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid user ID from the server'),
              ),
            );
          }
        } else {
          // Invalid response format from the server
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid response format from the server'),
            ),
          );
        }
      } else {
        // Error in login
        print('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error in login'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
