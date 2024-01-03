import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseURL = '12233615.000webhostapp.com';

class Dinner {
  int _id;
  String _name;
  double _price;
  String _imageURL;
  Dinner(this._id, this._name, this._price, this._imageURL);

  @override
  String toString() {
    return 'ID: $_id Name: $_name Price: \$$_price';
  }
  String get imageURL => _imageURL;
  String get name => _name;
  double get price => _price;
}
// list to hold products retrieved from getProducts
List<Dinner> _dinner = [];
// asynchronously update _products list
void updateDinner(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'dinner.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    _dinner.clear(); // clear old products
    if (response.statusCode == 200) { // if successful call
      final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
      for (var row in jsonResponse) { // iterate over all rows in the json array
        Dinner p = Dinner( // create a product object from JSON row object
            int.parse(row['id']),
            row['name'],
            double.parse(row['price']),
            row['image_url']);
        _dinner.add(p); // add the product object to the _products list
      }
      update(true); // callback update method to inform that we completed retrieving data
    }
  }
  catch(e) {
    update(false); // inform through callback that we failed to get data
  }
}

// shows products stored in the _products list as a ListView
class ShowDinner extends StatelessWidget {
  const ShowDinner({Key? key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _dinner.length,
      itemBuilder: (context, index) {
        return Center(
          child: Container(
            width: 300, // Set the fixed width for the container
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Image.network(
                      _dinner[index].imageURL,
                      height: 150,
                      width: 250, // Set the fixed width for the image
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dinner[index].name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Price: \$${_dinner[index].price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add to Cart logic here
                        // You can use this callback to handle the "Add to Cart" functionality
                        // For example, you might want to add the selected item to a cart state
                        // or perform any other actions based on your app's logic.
                      },
                      child: Text('Add to Cart'),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
