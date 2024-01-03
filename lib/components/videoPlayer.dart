import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  bool showControls = true;
  double _sliderValue = 0.0;
  late bool videoEnded;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
        _videoController.addListener(() {
          if (!_videoController.value.isPlaying &&
              _videoController.value.position ==
                  _videoController.value.duration) {
            setState(() {
              videoEnded = true;
            });
          } else {
            setState(() {
              videoEnded = false;
            });
          }
        });
      });
    videoEnded = false;

      Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_videoController.value.isPlaying) {
      setState(() {
      // Update slider value to match video position
      _sliderValue = _videoController.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  Icon displayIcon(){
    if (_videoController.value.isPlaying) {
      return const Icon(
        Icons.pause,
        size: 28,
        color: Colors.white,
      );
    } else if(_videoController.value.position == _videoController.value.duration){
      return const Icon(
        Icons.replay,
        size: 28,
        color: Colors.white,
      );
    }
    else {
      return const Icon(
        Icons.play_arrow_rounded,
        size: 28,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: 
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showControls = !showControls;
                    });
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                          child: Align(
                          alignment: Alignment.centerLeft,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.black, // Set the background color to black
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: _videoController.value.aspectRatio,
                                  child: VideoPlayer(_videoController),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ),
                      Visibility(
                        visible: showControls,
                        child: Positioned(
                          left: 1,
                          right: 1,
                          bottom: 1,
                          child: Column(
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children:[
                                  SizedBox(
                                    width: 50,
                                    child: Center(
                                      child: IconButton(
                                      iconSize: 28,
                                      color: Colors.white,
                                      icon: Icon(
                                      displayIcon().icon,
                                      ),
                                      onPressed: () {
                                      if (_videoController.value.isPlaying) {
                                        _videoController.pause();
                                      } else if(_videoController.value.position == _videoController.value.duration){
                                        setState(() {
                                        _videoController.seekTo(Duration.zero);
                                        _videoController.play();
                                        });
                                        
                                      }
                                      else {
                                        _videoController.play();
                                      }
                                      setState(() {});
                                                                    },
                                                                  ),
                                    ),
                                  ),
                                  Expanded(
                                     child: Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        min: 0.0,
                                        max: _videoController.value.duration.inSeconds.toDouble(),
                                        value: _videoController.value.position.inSeconds.toDouble(),
                                        onChanged: (double value) {
                                          setState(() {
                                          // Seek to the specified position
                                          _videoController.seekTo(Duration(seconds: value.toInt()));
                                          _sliderValue = value; // Update slider value
                                        });
                                      }
                                      ),
                                   ),
                                 ]
                               ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Align(
          alignment: Alignment.centerLeft,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: //loading indicator
                  Transform.scale(
                    scale: 0.2,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      color: //use the app bar color
                      Color(0xFF82618B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ); // Show a loading indicator while initializing
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}
