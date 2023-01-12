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
        color: Colors.black,
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
                              print(video);
                              List images = main2[index]["imagelist"];
                              funcwidget(id1, video, images);
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
                                      Border.all(width: 2, color: Colors.white),
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
                                      child: main2[index]["imagelist"].length !=
                                              0
                                          ? Image.file(
                                              File(
                                                  main2[index]["imagelist"][0]),
                                              fit: BoxFit.fill,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Description:"
                                              '${main2[index]["desc"]}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Images:"
                                              '${main2[index]["imagelist"].length}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Videos:"
                                              '${main2[index]["videolist"].length}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.95,
                      // color: Colors.black,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/imag.jpg"),
                            fit: BoxFit.fill),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Add New Widget ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
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
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  funcwidget(int idd, List videos, List images) async {
    print("VOd" + videos.toString());
    return await showDialog(
        context: context,
        builder: ((context) => Dialog(
              child: Container(
                height: 100,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Container(
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width - 150,
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
                                          RouteTwo(galleryItems: images)));
                                },
                                icon: Icon(Icons.explore)),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Home(video: videos)));
                                },
                                icon: Icon(Icons.play_circle)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.amber,
                      child: IconButton(
                          hoverColor: Colors.blueAccent,
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios_rounded)),
                    )
                  ],
                ),
              ),
            )));
  }
}
