import 'dart:io';

import 'package:cardoctor_chatapp/src/page/video_screen/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/send_message_response.dart';

class MessageVideo extends StatefulWidget {
  final String urlVideo;
  final bool isLeft;
  final String thumbnailUrl;
  final SendMessageResponse data;

  const MessageVideo({
    Key? key,
    required this.urlVideo,
    required this.isLeft,
    required this.thumbnailUrl,
    required this.data,
  }) : super(key: key);

  @override
  State<MessageVideo> createState() => _MessageVideoState();
}

class _MessageVideoState extends State<MessageVideo> {
  String formattedDuration = '';

  @override
  void initState() {
    super.initState();
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
          child: widget.thumbnailUrl != null
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoScreen(
                            // id: key,
                            url: widget.urlVideo,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: Image.file(File(widget.thumbnailUrl)),
                        ),
                        // if (!_videoController.value.isPlaying)
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(131, 158, 158, 158),
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                        // if (!_videoController.value.isPlaying)
                        const Center(
                          child: Icon(
                            Icons.play_circle_outline_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        // if (!_videoController.value.isPlaying)
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
                              widget.data.createdAtStr != null
                                  ? DateFormat('HH:mm').format(
                                      DateTime.parse(widget.data.createdAtStr!))
                                  : DateFormat('HH:mm').format(DateTime.now()),
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
              // _videoController.value.isInitialized
              //     ?

              : const AspectRatio(
                  aspectRatio: 16 / 9,
                ),
        ),
      ),
    );
  }
}
