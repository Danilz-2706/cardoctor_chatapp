import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cardoctor_chatapp/src/page/record_screen/preview_record.dart';
import 'package:cardoctor_chatapp/src/page/video_screen/video_screen.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.getVideo}) : super(key: key);
  final Function(String? url) getVideo;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
 Duration duration = Duration();
  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() {
        second=maxSecond;
        timer?.cancel();
        _isRecording = false;
      });
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PreviewRecord(filePath: file.path, getVideo: (String? url) {
          widget.getVideo.call(url);
        },),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      startTime();
      setState(() => _isRecording = true);
    }
  }

  static const maxSecond = 60;
  int second = maxSecond;
  Timer? timer;

  void resetTime()=> setState(() {
    second=maxSecond;
  });
  void startTime(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(second >0){
        setState(() {
          second--;
        });
      }
      else{
        stopTime();
      }
    });
  }
  void stopTime({bool reset = true}) async{
    if(reset){
      resetTime();
    }
    timer?.cancel();

    setState(() => _isRecording = true);
    final file = await _cameraController.stopVideoRecording();
    setState(() => _isRecording = false);
    final route = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => PreviewRecord(filePath: file.path, getVideo: (String? url) {
        widget.getVideo.call(url);
      },),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera'),
          elevation: 0,
          backgroundColor: Colors.black26,

        ),
        body: Center(
          child: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_cameraController),
             _buildTimer(),
              Positioned(
                bottom: 4,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(_isRecording ? Icons.stop : Icons.circle),
                    onPressed: () {
                      _recordVideo();
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  Widget _buildTimer(){
    String minutes = second==60?'01':'00';
    String seconds = second==60?'00':second>=10?'$second':'0$second';
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        decoration:const  BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Text('$minutes : $seconds', style:const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
      ),
    );
  }
}