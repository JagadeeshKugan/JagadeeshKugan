import "package:flutter/gestures.dart";
import 'dart:ui';
import 'folder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import './second.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

String? selct;

class _ScreenState extends State<Screen> {
  TextEditingController textController = TextEditingController();
  TextEditingController intervals = TextEditingController();
  Color color = Colors.white;

  final ValueNotifier<String?> selectedPath = ValueNotifier(null);
  void _pickFile(BuildContext context) async {
    selectedPath.value = null;

    final Directory rootPath = await getTemporaryDirectory();

    debugPrint('Root path: ${rootPath.absolute.path}');

    String? path = await FilesystemPicker.open(
      title: 'Open file',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.all,
      requestPermission: () async =>
          await Permission.storage.request().isGranted,
    );

    selectedPath.value = path;
  }

  @override
  Widget build(BuildContext context) {
    String text1 = textController.text;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.black, Colors.blue]),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(" Screen One "),
      ),
      body: Container(
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[400],
                  hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                  hintText: " TYPE DESCRIPTION HERE.... ",
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
                controller: textController,
                maxLines: null,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white38, boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 7, // blur radius
                  offset: Offset(0, 2),
                ),
              ]),
              height: 80,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Interval (seconds)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        width: 100,
                        child: TextField(
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[400],
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            hintText: "Enter here",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          controller: intervals,
                          maxLines: null,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(),
            SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Background color",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        pickcolor(context);
                      },
                      child: Text("Select"),
                    )
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: Text("Files    "),
                      leading: Radio(
                          value: "Files",
                          groupValue: selct,
                          onChanged: (value) {
                            setState(() {
                              selct = value;
                            });
                          }),
                    ),
                  ),
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PickImageVideo(
                                    color1: color,
                                    time: int.parse(intervals.text),
                                    text: text1,
                                  )));
                    },
                    child: Container(
                      height: 35,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("Choose"),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: Text("Folder    "),
                      leading: Radio(
                          value: "Folder",
                          groupValue: selct,
                          onChanged: (value) {
                            setState(() {
                              selct = value;
                            });
                          }),
                    ),
                  ),
                  // ignore: unnecessary_new
                  new GestureDetector(
                    onTap: () {
                      _pickFile(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Folder(
                                    text1: int.parse(intervals.text),
                                    text: text1,
                                    color1: color,
                                  )));
                    },
                    child: Container(
                      height: 35,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("Choose"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildcolor() => ColorPicker(
        pickerColor: color,
        onColorChanged: (color) => setState(
          () => this.color = color,
        ),
      );

  void pickcolor(BuildContext context) => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text("Select color"),
            content: Column(
              children: [
                buildcolor(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Select",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
          )));
}
