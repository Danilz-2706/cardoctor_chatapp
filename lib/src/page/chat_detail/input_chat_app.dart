import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cardoctor_chatapp/src/utils/custom_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../cardoctor_chatapp.dart';
import '../../model/send_message_request.dart';
import '../../utils/ImageVideoUploadManager/pic_image_video.dart';
import '../../utils/utils.dart';
import '../contains.dart';

class InputChatApp extends StatefulWidget {
  final Function(Map<String, dynamic>) press;
  final Function(Map<String, dynamic>) pressPickImage;
  final Function(Map<String, dynamic>) pressPickVideo;
  final Function(Map<String, dynamic>) pressPickFiles;
  final ChatAppCarDoctorUtilOption data;
  final Function(Map<String, dynamic>) typing;
  final Color? color;
  final dynamic dataRoom;
  final String idSender;
  const InputChatApp(
      {super.key,
      required this.press,
      required this.pressPickImage,
      required this.pressPickFiles,
      required this.pressPickVideo,
      required this.data,
      required this.typing,
      this.dataRoom,
      required this.idSender,
      this.color});

  @override
  State<InputChatApp> createState() => _InputChatAppState();
}

class _InputChatAppState extends State<InputChatApp> {
  FocusNode _focusNode = FocusNode();
  File? _video;
  late CameraController controllerCamera;

  ImagePicker picker = ImagePicker();

  late VideoPlayerController _videoPlayerController;
  late TextEditingController controller;
  String status = 'sending';
  List<File> filesList = [];

  Future getFile() async {
    filesList.clear();
    FilePickerResult? files = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (files != null) {
      filesList = files.paths.map((path) => File(path!)).toList();

      String fileName = filesList[0].path.split('/').last;
    } else {
      print("not choose file");
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      print('Người dùng đã không nhấn vào TextInput');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              PickImagesUtils.pickCameraOrRecordVideo(
                context,
                imagePicker: picker,
                onResultImagesFromGallery: (images) async {
                  try {
                    var x =
                        await Utils.onResultListMedia(context, images, true);
                    print(x);
                    print('ra ket qua');
                    if (x['type'] == 'MAX_SEND_IMAGE_CHAT') {
                      Utils.showToast(
                        context,
                        x['text'],
                        type: ToastType.ERROR,
                      );
                    } else if (x['type'] == 'LIMIT_CHAT_IMAGES_IN_MB') {
                      Utils.showToast(
                        context,
                        x['text'],
                        type: ToastType.ERROR,
                      );
                    } else {
                      var message = {
                        'key': 'files',
                        'list': images,
                      };
                      widget.pressPickImage(message);
                    }
                  } catch (e) {
                    print('dddd');
                  }
                },
                onResultVideoFromGallery: (file) async {
                  if (file != null) {
                    try {
                      var x =
                          await Utils.onResultListMedia(context, [file], true);
                      print(x);
                      print('ra ket qua');
                      if (x['type'] == 'LIMIT_CHAT_IMAGES_IN_MB') {
                        Utils.showToast(
                          context,
                          x['text'],
                          type: ToastType.ERROR,
                        );
                      } else {
                        var message = {
                          'key': 'files',
                          'list': [file],
                        };
                        widget.pressPickVideo(message);
                      }
                    } catch (e) {
                      print('dddd');
                    }
                  }
                },
                onResultImageFromCamera: (file) async {
                  if (file != null) {
                    print('Hinh dc chup');
                    print(file);
                    var message = {
                      'key': 'files',
                      'list': [file],
                    };
                    widget.pressPickImage(message);
                  }
                },
                onResultRecordVideo: (file) async {
                  if (file != null) {
                    print('Video dc chup');
                    print(file);
                    var message = {
                      'key': 'files',
                      'list': [file],
                    };
                    widget.pressPickVideo(message);
                  }
                },
              );
            },
            child: SvgPicture.asset(
              'assets/imgs/gallery.svg',
              semanticsLabel: 'Acme Logo',
              height: 24,
              width: 24,
              package: Consts.packageName,
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              await getFile();
              var message = {
                'key': 'files',
                'list': filesList,
              };
              widget.pressPickFiles(message);
            },
            child: SvgPicture.asset(
              'assets/imgs/link.svg',
              semanticsLabel: 'Acme Logo',
              height: 23,
              width: 23,
              package: Consts.packageName,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              maxLength: 500,
              maxLines: 5,
              minLines: 1,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  print('object');
                  widget.typing({
                    'id': widget.data.userIDReal,
                    'typing': true,
                  });
                } else {
                  print('object1');
                  widget.typing({
                    'id': widget.data.userIDReal,
                    'typing': false,
                  });
                }
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 26, 26, 26),
              ),
              controller: controller,
              decoration: InputDecoration(
                counterText: "",
                hintText: 'Nhập tin nhắn',
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.all(12),
                hintStyle: Theme.of(context).textTheme.subTitle.copyWith(
                      color: const Color(0xFFB0B0B0),
                    ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              if (controller.text != '') {
                var message = SendMessageRequest(
                  originalMessage: controller.text,
                  attachmentType: '',
                  linkPreview: "",
                  username: widget.idSender,
                  groupName: widget.data.groupName,
                );
                widget.typing({
                  'id': widget.data.userIDReal,
                  'typing': false,
                });

                widget.press(message.toMap());

                setState(() {
                  controller.text = '';
                  controller.clear();
                });
              }
            },
            child: SvgPicture.asset(
              'assets/imgs/send.svg',
              semanticsLabel: 'Acme Logo',
              height: 32,
              width: 32,
              package: Consts.packageName,
              color: widget.color ?? Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  // var dataSample=
  // {"id":'',"groupId":'',"userId":,"profileName":"Car Doctor Expert","originalMessage":"{\"key\":\"form\",\"value\":[],\"valueImage\":[],\"valueFiles\":[],\"urlVideo\":\"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4\"}","filteredMessage":"{\"key\":\"form\",\"value\":null,\"valueImage\":null,\"valueFiles\":null,\"urlVideo\":\"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4\"}","attachmentType":"image","attachment":null,"linkPreview":"","username":"Cardoctor1Driver","groupName":"GR_1693357083059","type":null,"createdAtStr":"2023-09-08T17:45:59","updatedAtStr":"2023-09-08T17:45:59","createdAt":"2023-09-08T17:45:59","updatedAt":"2023-09-08T17:45:59"}

}
