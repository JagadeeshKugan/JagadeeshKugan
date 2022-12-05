import 'dart:developer';
import 'dart:io' as io;
import 'dart:io';
import 'package:app1/home.dart';
import 'package:app1/image.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Folder extends StatefulWidget {
  final Color color1;
  final String text;
  final int text1;
  Folder(
      {required this.color1,
      required this.text,
      required this.text1,
      super.key});
  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  List file = [];
  List<String> videolist = [];

  late String directory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> setstring() async {
    String k = widget.text;
    final SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setString("s", k);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folder Info"),
        actions: [],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: (() async {
                final Directory rootPath = await getTemporaryDirectory();
                String? path1 = await FilesystemPicker.open(
                  title: 'pick folder',
                  context: context,
                  rootDirectory: rootPath,
                  fsType: FilesystemType.all,
                  requestPermission: () async =>
                      await Permission.storage.request().isGranted,
                );
                print(path1);
                directory = path1 ?? "";
                setState(() {
                  file = io.Directory("$directory/").listSync();
                  log(file.toString());
                });

                for (var a in file) {
                  final extension = p.extension(a.toString());
                  if (extension == '.png' ||
                      extension == '.jpg' ||
                      extension == ".jpeg") {
                    file.add(a);
                    print(file);
                    setstring();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => imagePage(
                            text: widget.text,
                            text1: widget.text1,
                            color3: widget.color1,
                            imagelist: file)));
                  } else if (extension == ".mp4") {
                    videolist.add(a.toString());
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: ((context) => Home())));
                  }
                }
              }),
              child: Icon(Icons.folder),
            ),
          ]),
    );
  }
}
