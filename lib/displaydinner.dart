import 'package:flutter/material.dart';
import 'dinner.dart';

class DisplayDinner extends StatefulWidget {
  const DisplayDinner({super.key});

  @override
  State<DisplayDinner> createState() => _HomeState();
}

class _HomeState extends State<DisplayDinner> {
  bool _load = false; // used to show products list or progress bar

  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) { // API request failed
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failedd to load data')));
      }
    });
  }


  @override
  void initState() {
    // update data when the widget is added to the tree the first tome.
    updateDinner(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // load products or progress bar
        body: _load ? const ShowDinner() : const Center(
            child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator())
        )
    );
  }
}