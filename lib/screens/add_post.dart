import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newsfeed/db/PostService.dart';
import 'package:newsfeed/models/post.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

File image;
String imgUrl;

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> formkey = new GlobalKey();
  Post post = Post(0, " ", " ");

  Future getImage() async {
    var img = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      image = img as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add post"),
        elevation: 0.0,
      ),
      body: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(25),
                  child: InkWell(
                    onTap: () => getImage(),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: image != null
                          ? FileImage(image)
                          : NetworkImage("null"),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Post title", border: OutlineInputBorder()),
                  onSaved: (val) => post.title = val,
                  validator: (value) {
                    return value.isEmpty || value.length > 16
                        ? "title cannot have more than 16 characters "
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Post body", border: OutlineInputBorder()),
                  onSaved: (val) => post.body = val,
                  validator: (value) {
                    return value.isEmpty || value.length > 16
                        ? "Invalid String, string should be less than 16 characters"
                        : null;
                  },
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          insertPost();
          Navigator.pop(context);
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        tooltip: "add a post",
      ),
    );
  }

  void insertPost() {
    final FormState form = formkey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      post.date = DateTime.now().millisecondsSinceEpoch;
      PostService postService = PostService(post.toMap());
      postService.addPost();
    }
  }
}
