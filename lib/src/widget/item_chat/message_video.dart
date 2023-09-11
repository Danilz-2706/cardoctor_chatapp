import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MessageVideo extends StatefulWidget {
  final String urlVideo;
  final bool isLeft;

  const MessageVideo({
    Key? key,
    required this.urlVideo,
    required this.isLeft,
  }) : super(key: key);

  @override
  State<MessageVideo> createState() => _MessageVideoState();
}

class _MessageVideoState extends State<MessageVideo> {
  late VideoPlayerController _videoController;
  String formattedDuration = '';

  @override
  void initState() {
    super.initState();
    if (widget.urlVideo.isNotEmpty) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.urlVideo))
            ..initialize().then((_) {
              var duration = _videoController.value.duration;

              if (duration.inHours > 0) {
                formattedDuration =
                    '${duration.inHours.toString().padLeft(2, '0')}:';
              }

              formattedDuration +=
                  '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

              setState(() {});
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
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
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: VideoPlayer(_videoController),
                        ),
                        if (!_videoController.value.isPlaying)
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(131, 158, 158, 158),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
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
                        if (!_videoController.value.isPlaying)
                          Positioned(
                            right: widget.isLeft ? 8 : null,
                            left: !widget.isLeft ? 8 : null,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Text(
                                formattedDuration,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(139, 141, 140, 1)),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
