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
    throw Exception('Failed to delete post');
  }
}

Future<EditPost> editPost(String id, String title, String desc) async {
  final http.Response response = await http.post(
    'http://localhost:8000/api/updatepost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': id,
      'title': title,
      'desc': desc,
    }),
  );

  if (response.statusCode == 200) {
    return EditPost.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update post');
  }
}

Future<CreatePost> createPost(String title, String desc) async {
  final http.Response response = await http.post(
    'http://localhost:8000/api/addposts',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'desc': desc,
    }),
  );

  if (response.statusCode == 200) {
    return CreatePost.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update post');
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

class CreatePost {
  final String success;

  CreatePost({this.success});

  factory CreatePost.fromJson(Map<String, dynamic> json) {
    return CreatePost(
      success: json['success'],
    );
  }
}

class EditPost {
  final String success;

  EditPost({this.success});

  factory EditPost.fromJson(Map<String, dynamic> json) {
    return EditPost(
      success: json['success'],
    );
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

void main() {
  runApp(new MaterialApp(
    title: 'Fetch Data Example',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
  //EditPostScreen createState() => EditPostScreen();
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
    return Scaffold(
      //title: 'Fetch Data Example',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      //home: Scaffold(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                );
                                // setState(() {

                                // });
                                //Navigator.pop(context);
                                print(eldata.title);
                              }),
                          new IconButton(
                              icon: new Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditPostScreen(post: eldata)),
                                );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostScreen()),
          )
        },
        tooltip: 'Add new',
        child: Icon(Icons.add),
      ),
      //),
    );
  }
}

class EditPostScreen extends StatelessWidget {
  String title_post;
  String description;
  Future<EditPost> _editPost;
  final title_insert = TextEditingController();
  final desc_insert = TextEditingController();
  final Post post;
  final GlobalKey<FormState> _formKey = GlobalKey();
  EditPostScreen({Key key, @required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit " + post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Title', hintText: post.title),
                    controller: title_insert,
                  ),
                  // this is where the
                  // input goes
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Description', hintText: post.description),
                    controller: desc_insert,
                  ),
                  RaisedButton(
                    onPressed: () {
                      //setState(() {
                      title_post = title_insert.text;
                      description = desc_insert.text;
                      if (title_insert.text.isEmpty) {
                        title_post = post.title;
                      }
                      if (desc_insert.text.isEmpty) {
                        description = post.description;
                      }
                      _editPost =
                          editPost(post.id.toString(), title_post, description);
                      //});
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                    child: Text("Update"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class NewPostScreen extends StatelessWidget {
  Future<CreatePost> _createPost;
  // bool validate_title = false;
  // bool validate_desc = false;
  final title_new = TextEditingController();
  final desc_new = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  // String checkString(String value) {
  //   if (value.isEmpty) {
  //     return "You must type something";
  //   } else {
  //     return null;
  //   }
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      //errorText: checkString(title_new.text),
                    ),
                    controller: title_new,
                  ),
                  // this is where the
                  // input goes
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      //errorText: checkString(desc_new.text),
                    ),
                    controller: desc_new,
                  ),
                  RaisedButton(
                    onPressed: () {
                      //setState(() {
                      // if (title_new.text.isEmpty) {
                      //   validate_title = true;
                      // }
                      // if (desc_new.text.isEmpty) {
                      //   validate_desc = true;
                      // }
                      if (_formKey.currentState.validate()) {
                        print("vuoto");
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      } else {
                        print(title_new.text + " spazio " + desc_new.text);
                        _createPost = createPost(title_new.text, desc_new.text);
                        //});
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
