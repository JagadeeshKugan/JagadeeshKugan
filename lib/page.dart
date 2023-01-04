import 'dart:convert';
import 'dart:io';

import 'package:app1/first.dart';
import 'package:app1/home.dart';
import 'package:app1/image.dart';
import 'package:app1/main.dart';
import 'package:app1/second.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pager extends StatefulWidget {
  const Pager({super.key});

  @override
  State<Pager> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  Future<bool> showExitPopup() async {
    return await showDialog(
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

  List<Map> main2 = [];

  geter() async {
    List<String> map = [];
    final SharedPreferences preff = await SharedPreferences.getInstance();
    map = preff.getStringList("encode") ?? [];
    List<Map<String, dynamic>> main = [];
    if (map.isNotEmpty) {
      map.forEach((element) {
        main.add(jsonDecode(element));
      });
    }
    main2.addAll(main);
    print(main2);
    setState(() {});
  }

  void initState() {
    super.initState();
    geter();
  }

  /*{
      "id": 1,
      "desc": "jame",
      "imagelist": [],
      "videolist": [],
      "cross": 3,
      "color": Colors.red
    },
    {
      "id": 2,
      "desc": "jam",
      "imagelist": [],
      "videolist": [],
      "cross": 3,
      "color": Colors.blue
    },
    {
      "id": 3,
      "desc": "KAte",
      "imagelist": [],
      "videolist": [],
      "cross": 3,
      "color": Colors.green
    },
    {
      "id": 4,
      "desc": "vint",
      "imagelist": [],
      "videolist": [],
      "cross": 3,
      "color": Colors.yellow
    },*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Home"),
        centerTitle: true,
        leading: IconButton(
            onPressed: (() {
              showExitPopup();
            }),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              main2.length > 0
                  ? Container(
                      height: MediaQuery.of(context).size.height * .85,
                      width: MediaQuery.of(context).size.width * .90,
                      child: ListView.builder(
                        itemCount: main2.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // ignore: unnecessary_new
                          return new GestureDetector(
                            onLongPress: () {
                              int id1 = main2[index]["id"];
                              List video = main2[index]["videolist"];
                              funcwidget(id1, video);
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => imagePage(
                                        text: main2[index]["desc"],
                                        text1: main2[index]["cross"],
                                        color3: main2[index]["color"],
                                        id: main2[index]["id"],
                                        imagelist: main2[index]["imagelist"])),
                              );
                            },
                            child: Container(
                              height: 120,
                              margin: EdgeInsetsDirectional.all(10),
                              //child: //kIsWeb
                              //? Image.network(paths[index])
                              // : Image.file(File(paths[index])) as dynamic,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                  color: Color(int.parse(
                                      main2[index]["color"].toString())),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Column(
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width *
                                          .75,
                                      child: main2[index]["imagelist"] != null
                                          ? Image.file(
                                              File(
                                                  main2[index]["imagelist"][0]),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .90,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(Icons.image),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                      height: 20,
                                      child: Center(
                                          child: Text(
                                        "Description:"
                                        '${main2[index]["desc"]}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Add New Widget ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
              Container(
                child: FloatingActionButton(
                  hoverColor: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => Screen(
                              id: 0,
                            ))));
                  },
                  child: Icon(Icons.add),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  funcwidget(int idd, List videos) async {
    return await showDialog(
        context: context,
        builder: ((context) => Dialog(
              child: Container(
                height: 100,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      child: Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => Screen(
                                          id: idd,
                                        ))));
                              },
                              icon: Icon(Icons.settings)),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        RouteTwo(galleryItems: main2)));
                              },
                              icon: Icon(Icons.square_sharp)),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Home(video: videos)));
                              },
                              icon: Icon(Icons.youtube_searched_for)),
                        ],
                      ),
                    ),
                    IconButton(
                        hoverColor: Colors.blueAccent,
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_rounded))
                  ],
                ),
              ),
            )));
  }
}
