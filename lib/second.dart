import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:app1/image.dart';
import 'package:app1/page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app1/home.dart';

class PickImageVideo extends StatefulWidget {
  final String text;
  final int color1;
  final int id;
  final int time;
  const PickImageVideo(
      {super.key,
      required this.id,
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

    imagePicker = new ImagePicker();
  }

  //set prefs for videos
  /*Future<void> setList() async {
    List<String> b = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    b = prefs.getStringList("a") ?? [];
    for (var xfile in videolist) {
      b.add(xfile);
    }

    b.toSet().toString();

    prefs.setStringList('a', b);
  }*/

  //set desc in prefs
  Future<void> setstring() async {
    String k = widget.text;
    final SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setString("s", k);
  }

  //Set images list in pref
  List imageFileList = [];
  List<String> videolist = [];

  //set map
  seter() async {
    int id = widget.id;
    print(id);
    int color = widget.color1;
    List temp1 = [];
    List temp2 = [];
    List<String> map = [];
    //map
    final SharedPreferences preff = await SharedPreferences.getInstance();
    map = preff.getStringList("encode") ?? [];

    for (var xfile in videolist) {
      temp2.add(xfile);
    }

    //image list
    for (var xfile in imageFileList) {
      temp1.add(xfile.path);
    }

    List<Map<String, dynamic>> main = [];
    if (map.isNotEmpty) {
      map.forEach((element) {
        main.add(jsonDecode(element));
      });
    }
    print("main iin sec" + main.toString());

    if (id == 0) {
      int i = main.length + 1;
      Map<String, dynamic> mac = {
        "id": i,
        "desc": widget.text,
        "imagelist": temp1,
        "videolist": temp2,
        "cross": widget.time,
        "color": color
      };
      main.add(mac);
    } else if (id != 0) {
      var mape = main.firstWhere((item) => item["id"] == id);
      if (mape != null) {
        mape["imagelist"] += temp1;
        mape["videolist"] = mape["videolist"] + temp2;
      }
      if (widget.text != null) {
        main
            .firstWhere((element) => element["id"] == id)
            .update("desc", (value) => widget.text);
      }
      if (widget.time != null) {
        main
            .firstWhere((element) => element["id"] == id)
            .update("cross", (value) => widget.time);
      }

      main
          .firstWhere((element) => element["id"] == id)
          .update("color", (value) => color);
      main
          .firstWhere((element) => element["id"] == id)
          .update("imagelist", (value) => mape["imagelist"]);
      main
          .firstWhere((element) => element["id"] == id)
          .update("videolist", (value) => mape["videolist"]);
    }

    List<String> map1 = [];
    main.forEach((element) {
      map1.add(jsonEncode(element));
    });

    preff.setStringList("encode", map1);
  }

  //shared imag list
  /* crec() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = prefs.getStringList("b") ?? [];
    for (var xfile in imageFileList) {
      temp.add(xfile.path);
    }

    prefs.setStringList('b', temp);
  }*/

  //select multiple images
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
    seter();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => Pager()));
  }

  // picking video
  void pickVideoFromGallery() async {
    XFile _video = await imagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      videolist.add(_video.path);
    });

    seter();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => Pager()));
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
        color: Color(widget.color1),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      minWidth: 100,
                      color: Colors.blue,
                      onPressed: () {
                        pickVideoFromGallery();
                      },
                      child: Text("Select video "),
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
