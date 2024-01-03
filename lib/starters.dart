import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseURL = '12233615.000webhostapp.com';

class Starters {
  int _id;
  String _name;
  double _price;
  String _imageURL;
  Starters(this._id, this._name, this._price, this._imageURL);

  @override
  String toString() {
    return 'ID: $_id Name: $_name Price: \$$_price';
  }

  int get id => _id;
  String get imageURL => _imageURL;
  String get name => _name;
  double get price => _price;
}
// list to hold products retrieved from getProducts
List<Starters> _starters = [];
// asynchronously update _products list
void updateStarters(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'starters.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    _starters.clear(); // clear old products
    if (response.statusCode == 200) { // if successful call
      final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
      for (var row in jsonResponse) { // iterate over all rows in the json array
        Starters p = Starters( // create a product object from JSON row object
            int.parse(row['id']),
            row['name'],
            double.parse(row['price']),
            row['image_url']);
        _starters.add(p); // add the product object to the _products list
      }
      update(true); // callback update method to inform that we completed retrieving data
    }
  }
  catch(e) {
    update(false); // inform through callback that we failed to get data
  }
}

// shows products stored in the _products list as a ListView
class ShowStarters extends StatelessWidget {
  final int userId;
  final Function(Starters starter, int userId) addToCartCallback;

  const ShowStarters({Key? key, required this.userId, required this.addToCartCallback,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _starters.length,
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
                      _starters[index].imageURL,
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
                          _starters[index].name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Price: \$${_starters[index].price.toStringAsFixed(2)}',
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
                        addToCartCallback(_starters[index], userId);
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
