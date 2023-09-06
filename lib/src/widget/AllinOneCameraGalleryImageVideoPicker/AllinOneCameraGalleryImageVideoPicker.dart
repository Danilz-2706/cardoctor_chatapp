import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AllinOneCameraGalleryImageVideoPicker extends StatefulWidget {
  final Function(File file, bool isVideo, File? thumbnailFile) onTakeFile;
  final int? maxDurationInSeconds;
  const AllinOneCameraGalleryImageVideoPicker({
    Key? key,
    required this.onTakeFile,
    this.maxDurationInSeconds = 120,
  }) : super(key: key);
  @override
  _AllinOneCameraGalleryImageVideoPickerState createState() {
    return _AllinOneCameraGalleryImageVideoPickerState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

class _AllinOneCameraGalleryImageVideoPickerState
    extends State<AllinOneCameraGalleryImageVideoPicker>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  late List<CameraDescription> cameras;

  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  get() async {
    cameras = await availableCameras();
    onNewCameraSelected(cameras[0]);
  }

  @override
  void initState() {
    get();
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    controller!.dispose();
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller!.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CountDownController _timerController = CountDownController();
  DateTime? currentBackPressTime = DateTime.now();
  Future<bool> onWillPop() {
    if (controller != null &&
        controller!.value.isInitialized &&
        controller!.value.isRecordingVideo) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light));

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 30),
                  child: _cameraPreviewWidget(),
                )),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    controller != null &&
                            controller!.value.isInitialized &&
                            controller!.value.isRecordingVideo
                        ? const SizedBox(
                            width: 47,
                          )
                        : IconButton(
                            onPressed: () {
                              onNewCameraSelected(
                                  controller!.description == cameras[0]
                                      ? cameras[1]
                                      : cameras[0]);
                            },
                            icon: const Icon(
                              Icons.cameraswitch_rounded,
                              size: 40,
                              color: Colors.white,
                            )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller != null &&
                                  controller!.value.isInitialized &&
                                  controller!.value.isRecordingVideo
                              ? controller!.value.isRecordingPaused
                                  ? ""
                                  : "recording"
                              : "longpressforvideo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        HoldTimeoutDetector(
                            onTap: controller != null &&
                                    controller!.value.isInitialized &&
                                    !controller!.value.isRecordingVideo
                                ? onTakePictureButtonPressed
                                : null,
                            onTimeout: () {
                              onStopButtonPressed();
                            },
                            onTimerInitiated: () =>
                                onVideoRecordButtonPressed(),
                            onCancel: () => onStopButtonPressed(),
                            holdTimeout:
                                Duration(seconds: widget.maxDurationInSeconds!),
                            enableHapticFeedback: true,
                            child: controller != null &&
                                    controller!.value.isInitialized &&
                                    controller!.value.isRecordingVideo
                                ? Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3.8),
                                      color: Colors.redAccent,
                                    ),
                                    child: CircularCountDownTimer(
                                      duration: widget.maxDurationInSeconds!,
                                      initialDuration: 0,
                                      controller: _timerController,
                                      width: 32,
                                      height: 32,
                                      ringColor: Colors.grey[300]!,
                                      fillColor: Colors.red[200]!,
                                      fillGradient: null,
                                      backgroundColor:
                                          Colors.red.withOpacity(0.3),
                                      backgroundGradient: null,
                                      strokeWidth: 8.0,
                                      strokeCap: StrokeCap.round,
                                      textStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textFormat: CountdownTextFormat.S,
                                      isReverse: false,
                                      isReverseAnimation: false,
                                      isTimerTextShown: true,
                                      autoStart: false,
                                      onStart: () {
                                        debugPrint('Countdown Started');
                                      },
                                      onComplete: () {
                                        debugPrint('Countdown Ended');
                                      },
                                    ),
                                  )
                                : Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3.8),
                                      color: Color(0xff4CAF50),
                                    ),
                                    child: CircularCountDownTimer(
                                      duration: widget.maxDurationInSeconds!,
                                      initialDuration: 0,
                                      controller: _timerController,
                                      width: 32,
                                      height: 32,
                                      ringColor: Colors.grey[300]!,
                                      fillColor: Color(0xffC8E6C9),
                                      fillGradient: null,
                                      backgroundColor:
                                          Color(0xff4CAF50).withOpacity(0.3),
                                      backgroundGradient: null,
                                      strokeWidth: 4.0,
                                      strokeCap: StrokeCap.round,
                                      textStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textFormat: CountdownTextFormat.S,
                                      isReverse: false,
                                      isReverseAnimation: false,
                                      isTimerTextShown:
                                          controller!.value.isRecordingVideo,
                                      autoStart: false,
                                      onStart: () {
                                        // Here, do whatever you want
                                        debugPrint('Countdown Started');
                                      },
                                      onComplete: () {
                                        // Here, do whatever you want
                                        debugPrint('Countdown Ended');
                                      },
                                    ),
                                  )),
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          File? selectedMedia =
                              await pickMultiMedia(context).catchError((err) {
                            return null;
                          });

                          if (selectedMedia == null) {
                          } else {
                            String fileExtension =
                                p.extension(selectedMedia.path).toLowerCase();

                            if (fileExtension == ".png" ||
                                fileExtension == ".jpg" ||
                                fileExtension == ".jpeg") {
                              final tempDir = await getTemporaryDirectory();
                              File file = await File(fileExtension == ".png"
                                      ? '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png'
                                      : '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg')
                                  .create();
                              file.writeAsBytesSync(
                                  selectedMedia.readAsBytesSync());
                              controller!.dispose();
                              _flashModeControlRowAnimationController.dispose();
                              _exposureModeControlRowAnimationController
                                  .dispose();
                              widget.onTakeFile(file, false, null);
                            } else if (fileExtension == ".mp4" ||
                                fileExtension == ".mov") {
                              final tempDir = await getTemporaryDirectory();
                              File file = await File(
                                      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4')
                                  .create();
                              file.writeAsBytesSync(
                                  selectedMedia.readAsBytesSync());
                              widget.onTakeFile(file, true, null);
                            } else {
                              print(
                                  '"File type not supported. Please choose a valid .mp4, .mov, .jpg, .jpeg, .png file. \n\nSelected file was $fileExtension ');
                            }
                          }
                        },
                        icon: Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),

            Platform.isIOS
                ? Positioned(
                    top: MediaQuery.of(context).padding.top - 10,
                    right: 12,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )),
                  )
                : SizedBox()
            // _captureControlRowWidget()
          ],
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {}

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) async {
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        if (file != null) {
          widget.onTakeFile(File(file.path), false, null);

          Navigator.of(context).pop();
        }
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    HapticFeedback.heavyImpact();
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStopButtonPressed() {
    HapticFeedback.heavyImpact();
    stopVideoRecording().then((XFile? file) async {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        videoFile = file;
      }
    }).catchError((ee) {
      Navigator.of(context).pop();
    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      _timerController.start();
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  // ignore: unused_element
  Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }

    final VideoPlayerController vController = kIsWeb
        ? VideoPlayerController.network(videoFile!.path)
        : VideoPlayerController.file(File(videoFile!.path));

    videoPlayerListener = () {
      if (videoController != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) {
          setState(() {});
        }
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future<File?> pickMultiMedia(BuildContext context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        pathThumbnailSize: ThumbnailSize.square(84),
        gridCount: 3,
        pageSize: 900,
        requestType: RequestType.common,
        textDelegate: EnglishAssetPickerTextDelegate(),
      ),
    );
    if (result != null) {
      return result.first.file;
    }
    return null;
  }
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.

T? _ambiguate<T>(T? value) => value;
