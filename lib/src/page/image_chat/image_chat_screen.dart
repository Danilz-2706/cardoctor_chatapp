import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../utils/DownloadManager/download_all_file_type.dart';

class ImageChatScreen extends StatefulWidget {
  final String id;
  final bool local;
  final String url;
  const ImageChatScreen(
      {super.key, required this.id, required this.url, this.local = false});

  @override
  State<ImageChatScreen> createState() => _ImageChatScreenState();
}

class _ImageChatScreenState extends State<ImageChatScreen>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  bool showAppbar = true;
  bool process = false;
  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation!.value;
        if (controller.value.row0.a == 0.0 && controller.value.row3.a == 1.0) {
          setState(() {
            showAppbar = true;
          });
        } else {
          setState(() {
            showAppbar = false;
          });
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
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
            children: [
              GestureDetector(
                onDoubleTapDown: (details) => tapDownDetails = details,
                onDoubleTap: () {
                  final position = tapDownDetails!.localPosition;
                  const double scale = 3;
                  final x = -position.dx * (scale - 1);
                  final y = -position.dy * (scale - 1);
                  final zoom = Matrix4.identity()
                    ..translate(x, y)
                    ..scale(scale);

                  final end =
                      controller.value.isIdentity() ? zoom : Matrix4.identity();
                  animation = Matrix4Tween(
                    begin: controller.value,
                    end: end,
                  ).animate(CurveTween(curve: Curves.easeOut)
                      .animate(animationController));
                  animationController.forward(from: 0);
                },
                child: Hero(
                  tag: widget.id,
                  child: InteractiveViewer(
                    transformationController: controller,
                    scaleEnabled: true,
                    child: widget.local
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.file(
                              File(widget.url),
                              width: MediaQuery.of(context).size.width * 0.4,
                              fit: BoxFit.contain,
                            ),
                          )
                        : CachedNetworkImage(
                            placeholder: (context, url) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: const CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: const Icon(Icons.error),
                            ),
                            imageUrl: widget.url,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [],
                                  image: DecorationImage(
                                    onError: (exception, stackTrace) {},
                                    isAntiAlias: true,
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              if (showAppbar)
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
