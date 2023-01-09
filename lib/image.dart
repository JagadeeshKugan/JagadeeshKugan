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
  final String text; //desc
  final List imagelist; //imglist

  final int text1;
  final int color3;
  final int id;
  const imagePage(
      {required this.text,
      required this.text1,
      required this.color3,
      required this.imagelist,
      required this.id,
      super.key});

  @override
  State<imagePage> createState() => _imagePageState();
}

class _imagePageState extends State<imagePage> {
  List<String> paths = [];

  void setlistsimage() {
    for (var a in widget.imagelist) {
      paths.add(a);
    }
    setState(() {});
    print(paths);
  }

  /*List<String> ac = [];
  List<String> videolist = [];
  Future<void> getList1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ac = prefs.getStringList("a") ?? [];
    for (var b in ac) {
      videolist.add(b);
    }
  }*/

  void initState() {
    setlistsimage();

    // getList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Image Page"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: (() {
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => PickImageVideo(
                            id: widget.id,
                            color1: widget.color3,
                            text: widget.text,
                            time: widget.text1,
                          ))));
                }
              }),
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: (() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => Screen(
                          id: widget.id,
                        ))));
              }),
              icon: Icon(Icons.settings))
        ],
        leading: IconButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        color: Color(widget.color3),
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height * .90,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GridView.builder(
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
                          color: Color(widget.color3),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.white,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Text(
                        "Description:" + widget.text,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "No. of images:" + widget.imagelist.length.toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
