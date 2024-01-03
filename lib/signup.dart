import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'login.dart'; // Assuming you have a Login page

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 450.0,
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
                      'Sign Up',
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
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        // You can add more email validation logic here
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
                        }else if(value.length < 6) {
                          return 'Password is too short';
                        }
                        // You can add more password validation logic here
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          handleSignup(context);
                        }
                      },
                      child: Text('Register'),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account? Login here',
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

// Inside your SignupPage class

  // Inside your SignupPage class

  Future<void> handleSignup(BuildContext context) async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://12233615.000webhostapp.com/signup.php'),
        // Replace with your server URL
        body: {
          'username': username,
          'email': email,
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
            // User signed up successfully
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User registered successfully'),
              ),
            );

            // Navigate to the menu screen with the user ID and name
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
        // Error in signup
        print('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error in signup'),
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
    home: SignupPage(),
  ));
}