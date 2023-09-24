import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import '../../utils/DownloadManager/download_all_file_type.dart';

class VideoScreen extends StatefulWidget {
  // final String id;
  final String url;
  const VideoScreen({super.key, required this.url});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  bool process = false;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          var duration = _videoController.value.duration;

          setState(() {});
        });
      _videoController.addListener(() {
        if (_videoController.value.position ==
            _videoController.value.duration) {
          setState(() {
            _videoController.pause(); // Tạm dừng video khi kết thúc
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !process;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _videoController.value.isPlaying
                                  ? _videoController.pause()
                                  : _videoController.play();
                            });
                          },
                          child: Stack(
                            children: [
                              VideoPlayer(_videoController),
                              if (!_videoController.value.isPlaying)
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(131, 158, 158, 158),
                                  ),
                                ),
                              if (!_videoController.value.isPlaying)
                                const Center(
                                  child: Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  color: const Color.fromARGB(113, 158, 158, 158),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await MobileDownloadService().download(
                            url: widget.url,
                            fileName: basename(widget.url),
                            context: this.context,
                            isOpenAfterDownload: false,
                            downloading: (p0) {
                              Future.delayed(
                                  const Duration(milliseconds: 1000));

                              setState(() {
                                process = p0;
                              });
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.file_download_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (process)
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: Color.fromARGB(95, 139, 139, 139),
                      child: const Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
