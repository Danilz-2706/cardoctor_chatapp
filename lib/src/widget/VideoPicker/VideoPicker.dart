import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HybridVideoPicker extends StatefulWidget {
  final String title;
  final Function callback;
  HybridVideoPicker({required this.callback, required this.title});
  @override
  _HybridVideoPickerState createState() => _HybridVideoPickerState();
}

class _HybridVideoPickerState extends State<HybridVideoPicker> {
  File? _video;
  String? error;

  ImagePicker picker = ImagePicker();

  late VideoPlayerController _videoPlayerController;

  // This funcion will helps you to pick a Video File
  _pickVideo() async {
    error = null;
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
    error = null;
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

  Widget _buildButtons() {
    return new ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(new Key('retake'), Icons.video_library_rounded,
                  () {
                _pickVideo();
                // Fiberchat.checkAndRequestPermission(Platform.isIOS
                //         ? Permission.mediaLibrary
                //         : Permission.storage)
                //     .then((res) {
                //   if (res) {
                //     _pickVideo();
                //   } else {
                //     Fiberchat.showRationale(
                //       getTranslated(context, 'pgv'),
                //     );
                //     Navigator.pushReplacement(
                //         context,
                //         new MaterialPageRoute(
                //             builder: (context) => OpenSettings(
                //                   prefs: widget.prefs,
                //                 )));
                //   }
                // });
              }),
              _buildActionButton(new Key('upload'), Icons.photo_camera, () {
                _pickVideoFromCamera();

                // Fiberchat.checkAndRequestPermission(Permission.camera)
                //     .then((res) {
                //   if (res) {
                //     _pickVideoFromCamera();
                //   } else {
                //     Fiberchat.showRationale(
                //       getTranslated(context, 'pcv'),
                //     );
                //     Navigator.pushReplacement(
                //         context,
                //         new MaterialPageRoute(
                //             builder: (context) => OpenSettings(
                //                   prefs: widget.prefs,
                //                 )));
                //   }
                // });
              }),
            ]));
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d2931),
      appBar: AppBar(
        elevation: 0.4,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 30,
            color: Color(0xff1d2931),
          ),
        ),
        backgroundColor: Color(0xff1d2931),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xff1d2931),
          ),
        ),
        actions: _video != null
            ? <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Color(0xff1d2931),
                    ),
                    onPressed: () {
                      _videoPlayerController.pause();

                      setState(() {
                        isLoading = true;
                      });

                      widget.callback(_video).then((videoUrl) {
                        Navigator.pop(context, videoUrl);
                      });
                    }),
                SizedBox(
                  width: 8.0,
                )
              ]
            : [],
      ),
      body: Stack(children: [
        new Column(children: [
          new Expanded(
              child: new Center(
                  child: error != null
                      ? fileSizeErrorWidget(error!)
                      : _buildVideo(context))),
          _buildButtons()
        ]),
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff00c166))),
                  ),
                  color: Color(0xff111920).withOpacity(0.6),
                )
              : Container(),
        )
      ]),
    );
  }

  Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
    return new Expanded(
      // ignore: deprecated_member_use
      child: new IconButton(
          key: key,
          icon: Icon(icon, size: 30.0),
          color: Color(0xff1d2931),
          onPressed: onPressed as void Function()?),
    );
  }
}

Widget fileSizeErrorWidget(String error) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 60, color: Colors.red[300]),
          SizedBox(
            height: 15,
          ),
          Text(error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red[300])),
        ],
      ),
    ),
  );
}
