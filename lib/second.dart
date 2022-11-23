import 'package:app1/image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app1/home.dart';

class PickImageVideo extends StatefulWidget {
  final String text;
  final Color color1;

  final int time;
  const PickImageVideo(
      {super.key,
      required this.color1,
      required this.time,
      required this.text});

  // receive data from the FirstScreen as a parameter

  @override
  State<PickImageVideo> createState() => _PickImageVideoState();
}

class _PickImageVideoState extends State<PickImageVideo> {
  var video;
  var imagePicker;

  @override
  void initState() {
    super.initState();
    Color color2 = widget.color1;
    imagePicker = new ImagePicker();
  }

//Selecting multiple images from Gallery
  List imageFileList = [];
  List<String> videolist = [];
  List<String> a = [];
  crec() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getStringList("a") ?? [];
    for (var xfile in imageFileList) {
      a.add(xfile.path);
    }

    await prefs.setStringList('a', a);
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
    crec();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => imagePage(
                  color3: widget.color1 as Color,
                  imagelist: a,
                  text: widget.text,
                  text1: widget.time,
                )));
  }

  void pickVideoFromGallery() async {
    XFile _video = await imagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      videolist.add(_video.path);
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => Home(
                  videolist: videolist,
                )));
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_left)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.black, Colors.blue]),
          ),
        ),
        title: Text("Second screen"),
      ),
      body: Container(
        color: widget.color1,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      minWidth: 100,
                      color: Colors.blue,
                      onPressed: () {
                        pickVideoFromGallery();
                      },
                      child: Text("Select video from Gallery"),
                    ),
                    MaterialButton(
                      minWidth: 100,
                      color: Colors.blue,
                      onPressed: () {
                        selectImages();
                      },
                      child: Text('Select Multiple Images'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Description " + widget.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text("Images: ${imageFileList.length}"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
