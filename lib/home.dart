import 'package:flutter/material.dart';
import 'displaystarters.dart';
import 'displaydinner.dart';
import 'signup.dart';
import 'displaycart.dart';

class Home extends StatefulWidget {
  final int? userId;
  final String? userName;

  const Home({Key? key, this.userId, this.userName}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];
  int? _localUserId;
  String? _localUserName;

  @override
  void initState() {
    _pages = [
      DisplayStarters(userId: widget.userId),
      const DisplayDinner(),
      const DisplayItemsPage(), // New page for the cart
    ];
    _localUserId = widget.userId;
    _localUserName = widget.userName;
    super.initState();
  }

  Future<void> handleLogout(BuildContext context) async {
    // Set local variables to null
    setState(() {
      _localUserId = null;
      _localUserName = null;
    });

    // After logout, navigate the user back to the login page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_localUserId != null ? 'Welcome, $_localUserName' : 'Menu'),
        centerTitle: true,
        actions: [
          if (_localUserId != null) // Display logout button only if user is logged in
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                handleLogout(context);
              },
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.food_bank),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.breakfast_dining),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart), // New cart icon
              onPressed: () {
                setState(() {
                  _selectedIndex = 2; // Switch to the cart page
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_localUserId == null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You are already logged in'),
              ),
            );
          }
        },
        child: const Icon(Icons.login),
      ),
    );
  }
}
