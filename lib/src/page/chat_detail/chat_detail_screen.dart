import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cardoctor_chatapp/src/utils/custom_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path/path.dart' as p;
import '../../cardoctor_chatapp.dart';
import '../../model/create_room_chat_response.dart';
import '../../model/form_text.dart';
import '../../model/send_message_request.dart';
import '../../model/send_message_response.dart';
import '../../utils/utils.dart';
import '../../widget/AllinOneCameraGalleryImageVideoPicker/AllinOneCameraGalleryImageVideoPicker.dart';
import '../../widget/appbar.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/receiver_card.dart';
import '../../widget/sender_card.dart';
import '../contains.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatAppCarDoctorUtilOption data;
  final dynamic dataRoom;
  final String idSender;
  final Function(Map<String, dynamic>) press;
  final Function(Map<String, dynamic>) pressPickImage;
  final Function(Map<String, dynamic>) pressPickFiles;
  final Function(Map<String, dynamic>) loadMoreHistory;
  final List<Map<String, dynamic>> historyChat;

  final VoidCallback pressBack;
  final Widget? stackWidget;
  final String? nameTitle;
  const ChatDetailScreen({
    Key? key,
    required this.data,
    required this.press,
    required this.pressBack,
    required this.dataRoom,
    this.stackWidget,
    required this.idSender,
    this.nameTitle,
    required this.pressPickImage,
    required this.pressPickFiles,
    required this.loadMoreHistory,
    required this.historyChat,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  var _scrollController = ScrollController();
  var _isVisible = false;
  late final IOWebSocketChannel channel;
  FocusNode _focusNode = FocusNode();
  List<SendMessageResponse> listMessage = [];
  File? _video;
  late CameraController controllerCamera;

  ImagePicker picker = ImagePicker();

  late VideoPlayerController _videoPlayerController;
  late TextEditingController controller;

  List<File> filesList = [];
  Future getImage() async {
    filesList.clear();
    ImagePicker imagePicker = ImagePicker();
    final List<XFile> imageFile =
        await imagePicker.pickMultiImage().catchError((e) {});
    if (imageFile.isNotEmpty) {
      for (var e in imageFile) {
        filesList.add(File(e.path));
      }
    } else {}
  }

  // This funcion will helps you to pick a Video File
  _pickVideo() async {
    XFile? pickedFile = await (picker.pickVideo(source: ImageSource.gallery));

    _video = File(pickedFile!.path);

    // if (_video!.lengthSync() / 1000000 > observer.maxFileSizeAllowedInMB) {
    if (_video == null) {
      //   error =
      //       '${getTranslated(this.context, 'maxfilesize')} ${observer.maxFileSizeAllowedInMB}MB\n\n${getTranslated(this.context, 'selectedfilesize')} ${(_video!.lengthSync() / 1000000).round()}MB';

      setState(() {
        _video = null;
      });
    } else {
      print("Video path");
      print(_video);
      setState(() {});
      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    }
  }

  // This funcion will helps you to pick a Video File from Camera
  _pickVideoFromCamera() async {
    XFile? pickedFile = await (picker.pickVideo(source: ImageSource.camera));

    _video = File(pickedFile!.path);

    if (_video == null) {
      //   error =
      //       '${getTranslated(this.context, 'maxfilesize')} ${observer.maxFileSizeAllowedInMB}MB\n\n${getTranslated(this.context, 'selectedfilesize')} ${(_video!.lengthSync() / 1000000).round()}MB';

      setState(() {
        _video = null;
      });
    } else {
      setState(() {});
      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    }
  }

  _buildVideo(BuildContext context) {
    if (_video != null) {
      return _videoPlayerController.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            )
          : Container();
    } else {
      return new Text('takefile',
          style: new TextStyle(
            fontSize: 18.0,
            color: Color(0xff8596a0),
          ));
    }
  }

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

  Future doWithIcon() async {}
  Future doWithFormReviewQuotes() async {}

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      print('Người dùng đã không nhấn vào TextInput');
    }
  }

  scrollToEnd() {
    final double end = _scrollController.position.minScrollExtent;
    _scrollController.animateTo(end,
        curve: Curves.easeIn, duration: Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    List<SendMessageResponse> sample = [];
    if (widget.historyChat != null) {
      for (var e in widget.historyChat) {
        sample.add(SendMessageResponse.fromMap(e));
      }
      setState(() {
        listMessage.addAll(sample);
      });
    }

    channel = IOWebSocketChannel.connect(
      Uri.parse('wss://' +
          widget.data.cluseterID +
          '.piesocket.com/v3/' +
          widget.data.groupName +
          '?api_key=' +
          widget.data.apiKey +
          '&notify_self=1'),
    );
    print('Connect socket');
    connectWebsocket();
    _focusNode.addListener(_handleFocusChange);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        print("scroll to top");
        widget.loadMoreHistory({});
      }

      if (_scrollController.offset ==
          _scrollController.position.minScrollExtent) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  _takeCameraImage(ValueChanged<String?> callBack) async {
    if (Platform.isIOS && await Permission.camera.isPermanentlyDenied) {
      // Utils.showPopupYesNoButton(
      //     context: context,
      //     contentText: R.string.msg_open_image_setting.tr(),
      //     submitCallback: () {
      //       openAppSettings();
      //       callBack.call(null);
      // });
      return;
    }
    final permission = await Permission.camera.request();
    if (Platform.isAndroid && permission.isPermanentlyDenied) {
      // Utils.showPopupYesNoButton(
      //     context: context,
      //     contentText: R.string.msg_open_image_setting.tr(),
      //     submitCallback: () {
      //       openAppSettings();
      //       callBack.call(null);
      //     });
      return;
    }
    if (permission.isGranted) {
      final String? image = await _getImage(ImageSource.camera);
      callBack.call(image);
      return;
    }
    callBack.call(null);
  }

  _getImage(ImageSource source) async {
    //Pick image
    try {
      final XFile? image = await picker.pickImage(
          source: source, imageQuality: 100, maxHeight: 1920, maxWidth: 1080);
      if (image == null) return null;

      //Handle crop
      // final String? cropPath = await _cropImage(image);
      // if (cropPath == null) return null;

      // String? error = await _checkValidImage(XFile(cropPath));
      // if (error != null) {
      //   if (widget.errorMessage != null) widget.errorMessage!(error);
      //   return null;
      // }
      return image;
    } catch (e) {}
  }

  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  connectWebsocket() {
    print('socketreturn');

    try {
      channel.stream.asBroadcastStream().listen(
            (message) {
              print('socketreturn123');
              print(message);
              listMessage.insert(
                  0, SendMessageResponse.fromMap(json.decode(message)));
              setState(() {});
            },
            cancelOnError: true,
            onError: (error) {
              if (kDebugMode) {
                print(error);
              }
            },
            onDone: () {},
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future addMessage(SendMessageRequest message) async {
    try {
      channel.sink.add(json.encode(message));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColors,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBarReview(
              avatar: 'assets/imgs/avatar.png',
              press: widget.pressBack,
              title: widget.nameTitle ?? '',
              isList: false,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: listMessage.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: Text(
                                  "Gửi tin nhắn đến chuyên gia của chúng tôi để tư vấn nhé!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kTextGreyDarkColors,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              itemCount: listMessage.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                bool old = true;
                                if (index == listMessage.length - 1) {
                                } else {
                                  if (formatMessageDate(
                                      listMessage[index].createdAtStr!,
                                      listMessage[index + 1].createdAtStr!)) {
                                    old = false;
                                  } else {
                                    old = true;
                                  }
                                }
                                print(index);
                                print(old);
                                if (index > 0 &&
                                    listMessage[index].username ==
                                        widget.data.userIDReal &&
                                    listMessage[index - 1].username ==
                                        widget.data.userIDReal) {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 4),
                                    child: SenderCard(
                                      listFiles: sampleFile,
                                      data: listMessage[index],
                                      listForm: sample,
                                      listImages: images,
                                      old: old,
                                      seen: true,
                                    ),
                                  );
                                }
                                if (index > 0 &&
                                    listMessage[index].username ==
                                        widget.data.userIDReal &&
                                    listMessage[index - 1].username !=
                                        widget.data.userIDReal) {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 12, top: 4),
                                    child: SenderCard(
                                      listFiles: sampleFile,
                                      data: listMessage[index],
                                      listForm: sample,
                                      listImages: images,
                                      old: old,
                                      seen: true,
                                    ),
                                  );
                                }
                                if (listMessage[index].username ==
                                    widget.data.userIDReal) {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 4),
                                    child: SenderCard(
                                      listFiles: sampleFile,
                                      data: listMessage[index],
                                      listForm: sample,
                                      listImages: images,
                                      old: old,
                                      seen: true,
                                    ),
                                  );
                                }
                                if (index > 0 &&
                                    listMessage[index].username !=
                                        widget.data.userIDReal &&
                                    listMessage[index - 1].username !=
                                        widget.data.userIDReal) {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 4),
                                    child: ReceiverCard(
                                      listFiles: sampleFile,
                                      onlyOnePerson: true,
                                      data: listMessage[index],
                                      listForm: sample,
                                      listImages: images,
                                      old: old,
                                      seen: true,
                                    ),
                                  );
                                } else {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 4),
                                    child: ReceiverCard(
                                      listFiles: sampleFile,
                                      onlyOnePerson: false,
                                      listForm: sample,
                                      data: listMessage[index],
                                      listImages: images,
                                      old: old,
                                      seen: true,
                                    ),
                                  );
                                }
                                return const Text("Error");
                              },
                            ),
                    ),
                  ),
                  if (_isVisible)
                    Positioned(
                      right: 28,
                      bottom: 28,
                      child: GestureDetector(
                        onTap: () {
                          scrollToEnd();
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFF8D4E),
                          ),
                          child: const Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            if (widget.stackWidget != null) widget.stackWidget!,
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              color: Colors.white,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          actions: [
                            CupertinoActionSheetAction(
                                onPressed: () async {
                                  await getImage();
                                  var message = {
                                    'key': 'image',
                                    'list': filesList,
                                  };
                                  widget.pressPickImage(message);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Chọn ảnh',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subTitle
                                        .copyWith(color: Color(0xFF24138A)))),
                            CupertinoActionSheetAction(
                                onPressed: () async {
                                  await _pickVideo();

                                  Navigator.of(context).pop();
                                },
                                child: Text('Chọn video',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subTitle
                                        .copyWith(color: Color(0xFF24138A)))),

                            //Quay video
                            CupertinoActionSheetAction(
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AllinOneCameraGalleryImageVideoPicker(
                                                onTakeFile: (file, isVideo,
                                                    thumnail) async {
                                                  int timeStamp = DateTime.now()
                                                      .millisecondsSinceEpoch;
                                                  if (isVideo == true) {
                                                    String videoFileext =
                                                        p.extension(file.path);
                                                    String videofileName =
                                                        'Video-$timeStamp$videoFileext';
                                                    print('video');
                                                    print(videofileName);
                                                    // String? url =
                                                    // String? videoUrl =
                                                    //     await uploadSelectedLocalFileWithProgressIndicator(
                                                    //         file,
                                                    //         true,
                                                    //         false,
                                                    //         timeStamp,
                                                    //         filenameoptional:
                                                    //             videofileName);
                                                    // if (videoUrl != null) {
                                                    //   String? thumnailUrl =
                                                    //       await uploadSelectedLocalFileWithProgressIndicator(
                                                    //           thumnail!,
                                                    //           false,
                                                    //           true,
                                                    //           timeStamp);
                                                    // if (thumnailUrl != null) {
                                                    //   onSendMessage(
                                                    //       this.context,
                                                    //       videoUrl +
                                                    //           '-BREAK-' +
                                                    //           thumnailUrl +
                                                    //           '-BREAK-' +
                                                    //           videometadata! +
                                                    //           '-BREAK-' +
                                                    //           "$videofileName",
                                                    //       MessageType.video,
                                                    //       timeStamp);
                                                    //   await file.delete();
                                                    //   await thumnail.delete();
                                                    // }
                                                    // }
                                                  } else {
                                                    String imageFileext =
                                                        p.extension(file.path);
                                                    String imagefileName =
                                                        'IMG-$timeStamp$imageFileext';

                                                    print('file');
                                                    print(imagefileName);
                                                    // String? url =
                                                    //     await uploadSelectedLocalFileWithProgressIndicator(
                                                    //         file,
                                                    //         false,
                                                    //         false,
                                                    //         timeStamp,
                                                    //         filenameoptional:
                                                    //             imagefileName);
                                                    // if (url != null) {
                                                    //   onSendMessage(
                                                    //       this.context,
                                                    //       url,
                                                    //       MessageType.image,
                                                    //       timeStamp);
                                                    //   await file.delete();
                                                    // }
                                                  }
                                                },
                                              )));
                                },
                                child: Text('Quay / chụp',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subTitle
                                        .copyWith(color: Color(0xFF24138A)))),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Huỷ",
                                style: Theme.of(context)
                                    .textTheme
                                    .subTitle
                                    .copyWith(color: Color(0xFF24138A))),
                          ),
                        ),
                      );
                      // await getImage();
                      // var message = {
                      //   'key': 'image',
                      //   'list': filesList,
                      // };
                      // widget.pressPickImage(message);
                      // await _pickVideo();
                    },
                    child: Image.asset(
                      'assets/imgs/ic_gallary.png',
                      height: 24,
                      width: 24,
                      package: Consts.packageName,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await getFile();
                      var message = {
                        'key': 'files',
                        'list': filesList,
                      };
                      widget.pressPickFiles(message);
                    },
                    child: Image.asset(
                      'assets/imgs/ic_link.png',
                      height: 24,
                      width: 24,
                      package: Consts.packageName,
                    ),
                  ),
                  Container(
                    width: 204,
                    height: 52,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(246, 246, 246, 1),
                    ),
                    child: TextField(
                      focusNode: _focusNode,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                        } else {}
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 26, 26, 26),
                      ),
                      controller: controller,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Nhập nội dung chat",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 0,
                          bottom: 0,
                        ),
                      ),
                    ),
                  ),
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
                        // addMessage(message);
                        widget.press(message.toMap());

                        setState(() {
                          controller.text = '';
                        });
                      }
                    },
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: Image.asset(
                        'assets/imgs/ic_button_send.png',
                        package: Consts.packageName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool formatMessageDate(String dateBefor, String dateAfter) {
    try {
      var dateBefor1 = DateTime.parse(dateBefor);
      var dateAfter1 = DateTime.parse(dateAfter);

      Duration difference = dateBefor1.difference(
          DateTime(dateAfter1.year, dateAfter1.month, dateAfter1.day));

      if (difference.inDays == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

enum TypeSend { text, images, files }
