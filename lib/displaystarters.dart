import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'starters.dart';

class DisplayStarters extends StatefulWidget {
  final int? userId; // Change int to int?

  const DisplayStarters({Key? key, this.userId}) : super(key: key);

  @override
  State<DisplayStarters> createState() => _DisplayStarters();
}

class _DisplayStarters extends State<DisplayStarters> {
  bool _load = false; // used to show products list or progress
  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) {
        // API request failed
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  @override
  void initState() {
    // update data when the widget is added to the tree the first time.
    updateStarters(update);
    super.initState();
  }

  void addToCart(Starters starter, int userId) async {
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign in to add items to the cart'),
        ),
      );
      return;
    }
    print('User ID: $userId, Item Name: ${starter.name}, Item Price: ${starter.price}');
    try {
      final response = await http.post(
        Uri.parse('https://12233615.000webhostapp.com/add_to_cart.php'),
        body: {
          'item_name': starter.name,
          'item_price': starter.price.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Successfully added to the cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item added to cart successfully'),
          ),
        );
      } else {
        // Failed to add to cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item to cart'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // load products or progress bar
      body: _load
          ? ShowStarters(
        userId: widget.userId ?? 0, // Provide a default value (0 in this case)
        addToCartCallback: addToCart,
      )
          : const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
