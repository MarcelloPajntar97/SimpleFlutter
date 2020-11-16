/*
for backend API visit: https://github.com/MarcelloPajntar97/MicroserviceCRUD

*/

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<DataPost> fetchPost() async {
  final response = await http.get('http://localhost:8000/api/posts');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print(DataPost.fromJson(jsonDecode(response.body)));
    return DataPost.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load post');
  }
}

Future<DeletePost> deletePost(String id) async {
  final http.Response response = await http.post(
    'http://localhost:8000/api/deletepost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': id,
    }),
  );

  if (response.statusCode == 200) {
    return DeletePost.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class DataPost {
  final List<Post> success;

  DataPost({this.success});

  factory DataPost.fromJson(Map<String, dynamic> json) {
    return DataPost(success: parseDataPost(json));
    //success: json['success']);
  }

  static List<Post> parseDataPost(imagesJson) {
    var list = imagesJson['success'] as List;
    List<Post> imagesList = list.map((data) => Post.fromJson(data)).toList();
    return imagesList;
  }
}

class DeletePost {
  final String success;

  DeletePost({this.success});

  factory DeletePost.fromJson(Map<String, dynamic> json) {
    return DeletePost(
      success: json['success'],
    );
  }
}

class Post {
  final String description;
  final int id;
  final String title;
  final String created_at;
  final String updated_at;

  Post(
      {this.description,
      this.id,
      this.title,
      this.created_at,
      this.updated_at});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      description: json['description'],
      id: json['id'],
      title: json['title'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<DataPost> futurePost;
  Future<DeletePost> _deletePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: FutureBuilder<DataPost>(
          future: futurePost,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.success.length,
                    itemBuilder: (_, int position) {
                      final eldata = snapshot.data.success[position];
                      //final desc = "$imagesPath/${item.row[0]}.jpg";
                      return Card(
                          child: ListTile(
                        title: Text(eldata.title),
                        subtitle: Text(eldata.description),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            new IconButton(
                                icon: new Icon(Icons.delete),
                                onPressed: () {
                                  //select("AddCalibration");
                                  setState(() {
                                    _deletePost =
                                        deletePost(eldata.id.toString());
                                  });
                                  print(eldata.title);
                                }),
                            new IconButton(
                                icon: new Icon(Icons.edit),
                                onPressed: () {
                                  //select("AddCalibration");
                                }),
                          ],
                        ),
                        //leading: Icon(Icons.delete),
                      ));
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
