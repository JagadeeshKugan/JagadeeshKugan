import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import "package:better_player/better_player.dart";
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({required this.videolist, super.key});
  final List<String> videolist;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<BetterPlayerPlaylistState> _betterPlayerPlaylistStateKey =
      GlobalKey();

  List<String> b = [];
  List<BetterPlayerDataSource> videoPlayerDataSource = [];

  createDataSet() {
    log(widget.videolist.toString());
    for (String xpath in widget.videolist) {
      videoPlayerDataSource.add(
        BetterPlayerDataSource(BetterPlayerDataSourceType.file, xpath),
      );
    }

    log(videoPlayerDataSource.toString());
    setState(() {});
  }

  List<String> ac = [];
  Future<void> setList() async {
    await getList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var xfile in widget.videolist) {
      b.add(xfile);
    }

    prefs.setStringList('a', b);
  }

  Future<void> getList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ac = prefs.getStringList("a") ?? [];
    for (var b in ac) {
      widget.videolist.add(b);
    }
  }

  @override
  void initState() {
    setList();

    super.initState();
    getList();
    createDataSet();
  }

  crec() {
    return const BetterPlayerConfiguration(
      autoPlay: true,
      looping: true,
      fullScreenByDefault: false,
      allowedScreenSleep: false,
      expandToFill: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeRight
      ],
      controlsConfiguration: BetterPlayerControlsConfiguration(
        textColor: Colors.black,
        enableProgressBar: true,
        enableProgressBarDrag: true,
        enablePlayPause: true,
        iconsColor: Colors.black,
        controlsHideTime: Duration(seconds: 2),
        enableRetry: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              " Home",
              style: TextStyle(fontSize: 20),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.add))
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          (videoPlayerDataSource.length > 0)
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width - 30,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: BetterPlayerPlaylist(
                        key: _betterPlayerPlaylistStateKey,
                        betterPlayerConfiguration: BetterPlayerConfiguration(),
                        betterPlayerPlaylistConfiguration:
                            const BetterPlayerPlaylistConfiguration(),
                        betterPlayerDataSourceList: videoPlayerDataSource),
                  ))
              : Text("No Video Selected"),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {});
                    },
                    child: Icon(
                      Icons.fast_rewind,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {});
                    },
                    child: Icon(
                      Icons.fast_rewind,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  BetterPlayerPlaylistController? get _betterPlayerPlaylistController =>
      _betterPlayerPlaylistStateKey
          .currentState!.betterPlayerPlaylistController;
}
