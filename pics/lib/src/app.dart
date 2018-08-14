import 'package:flutter/material.dart';

// Only import get function from http package
import 'package:http/http.dart' show get;

import 'models/image_model.dart';

import 'dart:convert';

import 'widgets/image_list.dart';

class App extends StatefulWidget {
  createState() {
    return AppState();
  }
}

// * State would persist even if parent widget is re-rendered
class AppState extends State<App> {
  int counter = 0;
  List<ImageModel> images = [];

  void fetchImage() async {
    // fetch id from 1
    counter += 1;
    var response =
        await get('https://jsonplaceholder.typicode.com/photos/$counter');
    var imageModel = ImageModel.fromJson(json.decode(response.body));

    setState(() {
      images.add(imageModel);
    });
  }

  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lets see some images!'),
        ),
        body: ImageList(images),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          // * fetchImage is a ref
          onPressed: fetchImage,
        ),
      ),
    );
  }
}
