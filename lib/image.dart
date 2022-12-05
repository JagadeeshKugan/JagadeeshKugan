import 'dart:developer';
import 'dart:io';
import 'package:app1/home.dart';

import 'second.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'first.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class imagePage extends StatefulWidget {
  final String text;
  final List imagelist;
  final int text1;
  final Color color3;
  const imagePage(
      {required this.text,
      required this.text1,
      required this.color3,
      required this.imagelist,
      super.key});

  @override
  State<imagePage> createState() => _imagePageState();
}

class _imagePageState extends State<imagePage> {
  List<String> a = [];
  late String k = widget.text;
  List<String> paths = [];

  void setlistsimage() {
    for (var a in widget.imagelist) {
      paths.add(a);
    }
    setState(() {});
  }

  Future<void> getList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    paths = prefs.getStringList('b') ?? [];
    log("paths " + paths.toString());
    setState(() {});
  }

  Future<void> getstring() async {
    final SharedPreferences prefs1 = await SharedPreferences.getInstance();
    k = prefs1.getString('s') ?? " ";
  }

  List<String> ac = [];
  List<String> videolist = [];
  Future<void> getList1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ac = prefs.getStringList("a") ?? [];
    for (var b in ac) {
      videolist.add(b);
    }
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => exit(0),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void initState() {
    //setlistsimage();
    getList();

    // getList();
    getstring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Home"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: (() {
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => PickImageVideo(
                            color1: widget.color3,
                            text: widget.text,
                            time: widget.text1,
                          ))));
                }
              }),
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: (() {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) => Screen())));
              }),
              icon: Icon(Icons.settings))
        ],
        leading: IconButton(
            onPressed: (() {
              showExitPopup();
            }),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        color: widget.color3,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    crossAxisCount: widget.text1,
                  ),
                  itemCount: paths.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // ignore: unnecessary_new
                    return new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteTwo(
                              galleryItems: paths,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        child: kIsWeb
                            ? Image.network(paths[index])
                            : Image.file(File(paths[index])) as dynamic,
                        decoration: BoxDecoration(
                          color: widget.color3,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.white24,
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Description : " + widget.text,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("Images:" + paths.length.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      FloatingActionButton(
                          onPressed: (() {
                            getList1();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => Home())));
                          }),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RouteTwo extends StatefulWidget {
  final List galleryItems;

  const RouteTwo({required this.galleryItems, super.key});
  @override
  State<RouteTwo> createState() {
    return _RouteTwoState();
  }
}

class _RouteTwoState extends State<RouteTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(' Full Screen'),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.cancel))
          ],
        ),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: kIsWeb
                ? NetworkImage(widget.galleryItems[index])
                : FileImage(File(widget.galleryItems[index])) as dynamic,
            initialScale: PhotoViewComputedScale.contained * 1,
          );
        },
        itemCount: widget.galleryItems.length,
        scrollDirection: Axis.horizontal,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
