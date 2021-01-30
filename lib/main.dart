/*
for backend API visit: https://github.com/MarcelloPajntar97/MicroserviceCRUD

*/
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GlobalData {
  static String user_token;
}

Future<DataPost> fetchPost() async {
  final response = await http.get(
    'http://104.236.25.146/api/posts',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " + GlobalData.user_token
    },
  );

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
    'http://104.236.25.146/api/deletepost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " + GlobalData.user_token
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
    'http://104.236.25.146/api/updatepost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " + GlobalData.user_token
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
    'http://104.236.25.146/api/addposts',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " + GlobalData.user_token
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'desc': desc,
    }),
  );

  if (response.statusCode == 200) {
    return CreatePost.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create post');
  }
}

Future<String> login(String email, String password) async {
  final http.Response response = await http.post(
    'http://104.236.25.146/api/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  //GlobalData.status_login = await response.statusCode;
  if (response.statusCode == 200) {
    // //print(response.body);
    // Map<String, dynamic> token = jsonDecode(response.body);
    // GlobalData.user_token = token["token"];
    // GlobalData.status_login = response.statusCode;
    //return Auth.fromJson(jsonDecode(response.body));
    return response.body;
  } else {
    return null;
  }
}

Future<String> register(String name, String email, String password) async {
  final http.Response response = await http.post(
    'http://104.236.25.146/api/register',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'email': email,
      'password': password,
    }),
  );
  return response.body;

  //if (response.statusCode == 201) {
  //print(response.body);
  // Map<String, dynamic> token = jsonDecode(response.body);
  // GlobalData.user_token = token["success"]["token"];
  // GlobalData.status_login = response.statusCode;
  // return Auth.fromJson(jsonDecode(response.body));
  //   return response.body;
  // } else {
  //   return null;
  // }
}

Future<String> logout() async {
  final http.Response response = await http.post(
    'http://104.236.25.146/api/logout',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " + GlobalData.user_token
    },
  );

  if (response.statusCode == 200) {
    //GlobalData.user_token = "";
    //GlobalData.status_login = response.statusCode;
    //return Auth.fromJson(jsonDecode(response.body));
    return response.body;
  } else {
    return null;
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
  final int user_id;
  final String title;
  final String created_at;
  final String updated_at;

  Post(
      {this.description,
      this.id,
      this.user_id,
      this.title,
      this.created_at,
      this.updated_at});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      description: json['description'],
      id: json['id'],
      user_id: json['user_id'],
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
    home: new LoginScreen(),
  ));
}

//test
//test2ssssss
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
  //EditPostScreen createState() => EditPostScreen();
}

class _MyAppState extends State<MyApp> {
  Future<DataPost> futurePost;
  Future<DeletePost> _deletePost;
  //Future<Auth> _logout;

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
        automaticallyImplyLeading: false,
        title: Text('Fetch Data Example'),
        leading: GestureDetector(
          onTap: () async {
            var log = await logout();
            if (log != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              //GlobalData.status_login = 0;
            } else {
              print("logout failed");
            }
          },
          child: Icon(
            Icons.logout,
          ),
        ),
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
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
        tooltip: 'Add new',
        child: Icon(Icons.add),
      ),
      //),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewPostScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class LoginScreen extends StatelessWidget {
  //Future<String> _login;
  final email_insert = TextEditingController();
  final pass_insert = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login Screen"),
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
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: email_insert,
                  ),
                  // this is where the
                  // input goes
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: pass_insert,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      var jwt =
                          await login(email_insert.text, pass_insert.text);
                      var key = jsonDecode(jwt)['success'];
                      print(key);

                      if (jwt != null) {
                        //storage.write(key: "jwt", value: key);
                        GlobalData.user_token = key;
                        print(GlobalData.user_token);
                        //print("This is user token " + GlobalData.user_token);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                        //GlobalData.status_login = 0;
                      } else {
                        print("login failed");
                      }
                    },
                    child: Text("Login"),
                  ),
                  new FlatButton(
                    child: new Text('Create Account'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                  )
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

class RegisterScreen extends StatelessWidget {
  //Future<Auth> _register;
  final email_insert = TextEditingController();
  final pass_insert = TextEditingController();
  final name_insert = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Register Screen"),
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
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: name_insert,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: email_insert,
                  ),
                  // this is where the
                  // input goes
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: pass_insert,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        if (!EmailValidator.validate(email_insert.text)) {
                          displayDialog(
                              context, "Invalid Email", "insert a valid email");
                        } else {
                          var reg = await register(name_insert.text,
                              email_insert.text, pass_insert.text);
                          var check = jsonDecode(reg);
                          if (check.containsKey('success')) {
                            var key = jsonDecode(reg)['success'];
                            print(key);
                            GlobalData.user_token = key;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                            //GlobalData.status_login = 0;
                          } else if (check.containsKey('error')) {
                            if (check['error'].contains('email')) {
                              displayDialog(context, "Invalid Email",
                                  "The email is already used");
                              //print("The email is already used");
                            } else {
                              displayDialog(
                                  context, "Error", "Something went wrong!");
                              //print("Something went wrong!");
                            }
                          }
                        }
                      } on Exception catch (_) {
                        print('regsiter failed');
                      }
                    },
                    child: Text("Register"),
                  ),
                  new FlatButton(
                    child: new Text('Back to Login'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  )
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
                      if (!_formKey.currentState.validate()) {
                        //print("vuoto");
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      } else {
                        //print(title_new.text + " spazio " + desc_new.text);
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
