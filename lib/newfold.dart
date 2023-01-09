import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app1/page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'home.dart';
import 'image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_manager/file_manager.dart';

class fold extends StatefulWidget {
  final String text;
  final int text1;
  final Color color1;
  final int id;
  const fold(
      {required this.text,
      required this.id,
      required this.text1,
      required this.color1,
      super.key});

  @override
  State<fold> createState() => _foldState();
}

class _foldState extends State<fold> {
  final FileManagerController controller = FileManagerController();
  late String directory;
  final ValueNotifier<String> _path = ValueNotifier<String>('');
  List<String> videolist = [];
  List<String> afile = [];
  var isSelected = -1;

  //set video list

  crec1() async {
    int id = widget.id;
    print(id);
    int color = widget.color1.value;
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
    for (var xfile in afile) {
      temp1.add(xfile);
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
        "cross": widget.text1,
        "color": color
      };
      main.add(mac);
    } else if (id != 0) {
      var mape = main.firstWhere((item) => item["id"] == id);
      if (mape != null) {
        mape["imagelist"] += temp1;
        mape["videolist"] = mape["videolist"] + temp2;
      }
      main
          .firstWhere((element) => element["id"] == id)
          .update("desc", (value) => widget.text);
      main
          .firstWhere((element) => element["id"] == id)
          .update("cross", (value) => widget.text1);
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
    print("mainerrrr" + main.toString());
    List<String> map1 = [];
    main.forEach((element) {
      map1.add(jsonEncode(element));
    });

    preff.setStringList("encode", map1);
  }

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => createFolder(context),
                icon: Icon(Icons.create_new_folder_outlined),
              ),
              IconButton(
                onPressed: () => sort(context),
                icon: Icon(Icons.sort_rounded),
              ),
              IconButton(
                onPressed: () => selectStorage(context),
                icon: Icon(Icons.sd_storage_rounded),
              )
            ],
            title: Text("Folder"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                await controller.goToParentDirectory();
              },
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            child: FileManager(
              controller: controller,
              builder: (context, snapshot) {
                final List<FileSystemEntity> entities = snapshot;
                return ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    FileSystemEntity entity = entities[index];
                    return Card(
                      child: ListTile(
                        tileColor: isSelected == index
                            ? Color.fromARGB(255, 67, 129, 176)
                            : Colors.white,
                        selectedColor: isSelected == index
                            ? Color.fromARGB(255, 22, 12, 216)
                            : Colors.white,
                        leading: FileManager.isFile(entity)
                            ? Icon(Icons.feed_outlined)
                            : Icon(Icons.folder),
                        title: Text(FileManager.basename(entity)),
                        subtitle: subtitle(entity),
                        onLongPress: () {
                          List<FileSystemEntity> file = [];

                          directory = entity.path;

                          /*print(controller.getCurrentPath +
                              "/" +
                              FileManager.basename(entity));*/
                          setState(() {
                            isSelected = index;
                            file = io.Directory("$directory/")
                                .listSync(recursive: true, followLinks: false);
                          });

                          for (FileSystemEntity a in file) {
                            final extension = p.extension(a.path);

                            if (extension == '.png' ||
                                extension == '.jpg' ||
                                extension == ".jpeg") {
                              afile.add(a.path);
                            } else if (extension == ".mp4") {
                              videolist.add(a.path);
                            }
                          }
                          crec1();

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: ((context) => Pager())));
                        },
                        onTap: () async {
                          if (FileManager.isDirectory(entity)) {
                            // open the folder
                            controller.openDirectory(entity);

                            // delete a folder
                            // await entity.delete(recursive: true);

                            // rename a folder
                            // await entity.rename("newPath");

                            // Check weather folder exists
                            // entity.exists();

                            // get date of file
                            // DateTime date = (await entity.stat()).modified;
                          } else {
                            // delete a file
                            // await entity.delete();

                            // rename a file
                            // await entity.rename("newPath");

                            // Check weather file exists
                            // entity.exists();

                            // get date of file
                            // DateTime date = (await entity.stat()).modified;

                            // get the size of the file
                            // int size = (await entity.stat()).size;
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              "${FileManager.formatBytes(size)}",
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return Text("");
        }
      },
    );
  }

  selectStorage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageList
                        .map((e) => ListTile(
                              title: Text(
                                "${FileManager.basename(e)}",
                              ),
                              onTap: () {
                                controller.openDirectory(e);
                                Navigator.pop(context);
                              },
                            ))
                        .toList()),
              );
            }
            return Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text("Name"),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Size"),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Date"),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("type"),
                  onTap: () {
                    controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  createFolder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: folderName,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Create Folder
                      await FileManager.createFolder(
                          controller.getCurrentPath, folderName.text);
                      // Open Created Folder
                      controller.setCurrentPath =
                          controller.getCurrentPath + "/" + folderName.text;
                    } catch (e) {}

                    Navigator.pop(context);
                  },
                  child: Text('Create Folder'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
