import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: DisplayItemsPage(),
  ));
}

class DisplayItemsPage extends StatefulWidget {
  const DisplayItemsPage({Key? key}) : super(key: key);

  @override
  _DisplayItemsPageState createState() => _DisplayItemsPageState();
}

class _DisplayItemsPageState extends State<DisplayItemsPage> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse('https://12233615.000webhostapp.com/display_items.php'),
        // Replace with your server URL
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = json.decode(response.body);

        setState(() {
          items = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                items[index]['item_name'],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Price: \$${items[index]['item_price']}'),
            ),
          );
        },
      ),
    );
  }
}
