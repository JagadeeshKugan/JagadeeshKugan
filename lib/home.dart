import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import "package:better_player/better_player.dart";
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({required this.videolist, super.key});
  final List videolist;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerPlaylistConfiguration _betterPlayerPlaylistConfiguration;
  List b = [];
  List<BetterPlayerDataSource> v = [];

  createDataSet() {
    for (var xpath in widget.videolist) {
      v.add(
        BetterPlayerDataSource(BetterPlayerDataSourceType.file, xpath),
      );
    }

    return v;
  }

  List<String> ac = [];
  Future<void> setList() async {
    for (var xfile in widget.videolist) {
      b.add(xfile);
    }
    await getList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList('a', ac);
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
    crec();
    playlist();
  }

  playlist() {
    return BetterPlayerPlaylistConfiguration(
      loopVideos: false,
      nextVideoDelay: Duration(milliseconds: 500),
    );
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
      body: Container(
        child: Row(
          children: [
            BetterPlayerPlaylist(
                betterPlayerDataSourceList: v,
                betterPlayerConfiguration: crec(),
                betterPlayerPlaylistConfiguration:
                    _betterPlayerPlaylistConfiguration),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        Duration? videoDuration = await _betterPlayerController
                            .videoPlayerController!.position;
                        setState(() {
                          if (_betterPlayerController.isPlaying()!) {
                            Duration rewindDuration = Duration(
                                seconds: (videoDuration!.inSeconds - 2));
                            if (rewindDuration <
                                _betterPlayerController
                                    .videoPlayerController!.value.duration!) {
                              _betterPlayerController
                                  .seekTo(Duration(seconds: 0));
                            } else {
                              _betterPlayerController.seekTo(rewindDuration);
                            }
                          }
                        });
                      },
                      child: Icon(
                        Icons.fast_rewind,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_betterPlayerController.isPlaying()!)
                            _betterPlayerController.pause();
                          else
                            _betterPlayerController.play();
                        });
                      },
                      child: Icon(
                        _betterPlayerController.isPlaying()!
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Duration? videoDuration = await _betterPlayerController
                            .videoPlayerController!.position;
                        setState(() {
                          if (_betterPlayerController.isPlaying()!) {
                            Duration forwardDuration = Duration(
                                seconds: (videoDuration!.inSeconds + 5));
                            if (forwardDuration >
                                _betterPlayerController
                                    .videoPlayerController!.value.duration!) {
                              _betterPlayerController
                                  .seekTo(Duration(seconds: 0));
                              _betterPlayerController.pause();
                            } else {
                              _betterPlayerController.seekTo(forwardDuration);
                            }
                          }
                        });
                      },
                      child: Icon(
                        Icons.fast_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    _betterPlayerController.isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              onTap: () => setState(() {
                if (!_betterPlayerController.isFullScreen) {
                  _betterPlayerController.enterFullScreen();
                } else {
                  _betterPlayerController.exitFullScreen();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
