import 'dart:developer';
import 'package:app1/first.dart';
import 'package:app1/second.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import "package:better_player/better_player.dart";
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final List video;
  const Home({required this.video, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<BetterPlayerPlaylistState> _betterPlayerPlaylistStateKey =
      GlobalKey();

  List<BetterPlayerDataSource> videoPlayerDataSource = [];
  List<String> videolist = [];
  createDataSet() {
    log(videolist.toString());
    for (String xpath in videolist) {
      videoPlayerDataSource.add(
        BetterPlayerDataSource(BetterPlayerDataSourceType.file, xpath),
      );
    }

    log(videoPlayerDataSource.toString());
    setState(() {});
  }

  Future<void> getList() async {
    List ac = widget.video;
    for (var b in ac) {
      videolist.add(b);
    }
  }

  @override
  void initState() {
    super.initState();
    initStateFn();
  }

  initStateFn() async {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              " Videos",
              style: TextStyle(fontSize: 20),
            ),
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
                  height: MediaQuery.of(context).size.height - 112,
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 20 / 15,
                      child: BetterPlayerPlaylist(
                          key: _betterPlayerPlaylistStateKey,
                          betterPlayerConfiguration:
                              BetterPlayerConfiguration(),
                          betterPlayerPlaylistConfiguration:
                              const BetterPlayerPlaylistConfiguration(),
                          betterPlayerDataSourceList: videoPlayerDataSource),
                    ),
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
