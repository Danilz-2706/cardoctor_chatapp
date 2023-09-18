// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';
// import 'package:camera/camera.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';

// class RecordMain extends StatefulWidget {
//   const RecordMain({Key? key}) : super(key: key);

//   @override
//   State<RecordMain> createState() => _RecordMainState();
// }

// CurrentRemainingTime(
//     {int? days,
//     int? hours,
//     int? min,
//     int? sec,
//     Animation<double>? milliseconds}) {
//   // TODO: implement CurrentRemainingTime
//   throw UnimplementedError();
// }

// class _RecordMainState extends State<RecordMain> {
//   get myIcon => null;
//   bool _isObscure = true;
//   final globalKey = GlobalKey<ScaffoldState>();

//   int ellipseState = 0;
//   bool _isVisible_recPopup = false;
//   bool _isVisible_recordTime = false;
//   bool _isVisible_beforeRec = true;
//   bool _isVisible_ellipse = true;
//   bool _isVisible_endEllipse = false;
//   bool _isVisible_afterVideoOptions = false;

//   String? filePath;
//   bool _isRecording = false;
//   bool _isFrontCamera = true;
//   List<CameraDescription>? cameras; //list out the camera available
//   CameraController? controller; //controller for camera
//   XFile? image; //for caputred image

//   @override
//   void initState() {
//     // isSelected = [true, false, false];
//     loadCamera();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   loadCamera() async {
//     cameras = await availableCameras();
//     if (cameras != null) {
//       if (_isFrontCamera) {
//         controller = CameraController(cameras![1], ResolutionPreset.max);
//       } else {
//         controller = CameraController(cameras![0], ResolutionPreset.max);
//       }
//       //cameras[0] = first camera, change to 1 to another camera

//       controller!.initialize().then((_) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {});
//       });
//     } else {
//       print("NO any camera found");
//     }
//   }

//   _stopVideoRecording() async {
//     if (_isRecording) {
//       final file = await controller?.stopVideoRecording();
//       filePath = file?.path;
//       print(file?.path);
//       setState(() => _isRecording = false);
//       final route = MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (_) => VideoPreview(filePath: filePath.toString()),
//       );
//       Navigator.push(context, route);
//     }
//   }

//   _recordVideo() async {
//     if (_isRecording) {
//       final file = await controller?.stopVideoRecording();
//       filePath = file?.path;
//       print(file?.path);
//       setState(() => _isRecording = false);
//       final route = MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (_) => VideoPreview(filePath: filePath.toString()),
//       );
//       Navigator.push(context, route);
//     } else {
//       await controller?.prepareForVideoRecording();
//       await controller?.startVideoRecording();
//       setState(() => _isRecording = true);
//     }
//   }

//   void onEnd() {
//     print("object");
//   }

//   void showReadyState_Active() {
//     setState(() {
//       print('starting...');
//       _isVisible_beforeRec = false;
//       _isVisible_recPopup = true;
//       _isVisible_recordTime = false;
//       _isVisible_ellipse = false;
//       _isVisible_endEllipse = true;
//     });
//   }

//   void State_RecordingEnd() {
//     setState(() {
//       _isVisible_recordTime = false;
//       _isVisible_ellipse = true;
//       _isVisible_endEllipse = false;
//       _isVisible_afterVideoOptions = true;
//     });
//     _stopVideoRecording();
//     print('Video Ended');
//   }

//   void showReadyState_inActive() {
//     setState(() {
//       _isVisible_recPopup = false;
//       _isVisible_recordTime = true;
//       _isVisible_ellipse = false;
//       _isVisible_endEllipse = true;
//       ellipseState = 1;
//     });
//     _recordVideo();
//     print('recording...');
//   }

//   void recording_Stop() {
//     setState(() {
//       _isVisible_recordTime = false;
//       _isVisible_ellipse = false;
//       _isVisible_afterVideoOptions = true;
//     });
//     _stopVideoRecording();
//     print('End recording...');
//   }

//   @override
//   Widget build(BuildContext context) {
//     var inputLabelStyle = const TextStyle(
//       fontSize: 10,
//       height: 0,
//       color: const Color(0xff202020),
//     );
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     int readyRecordingState = 0;
//     int a = 0;

//     int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
//     int readyRecording = DateTime.now().millisecondsSinceEpoch + 1000 * 4;

//     return Scaffold(
//       key: globalKey,
//       backgroundColor: const Color(0xffffffff),
//       resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(0),
//           child: Container(
//             width: screenWidth,
//             height: screenHeight,
//             decoration: BoxDecoration(
//               color: Colors.black,
//             ),
//             child: Column(
//               children: [
//                 Stack(
//                   children: [
//                     controller == null
//                         ? Center(child: Text("Loading Camera..."))
//                         : !controller!.value.isInitialized
//                             ? Center(
//                                 child: CircularProgressIndicator(),
//                               )
//                             : Align(
//                                 alignment: Alignment.center,
//                                 child: Padding(
//                                   padding:
//                                       EdgeInsets.only(top: screenHeight / 20),
//                                   child: Container(
//                                     width: screenWidth,
//                                     child: CameraPreview(controller!),
//                                   ),
//                                 ),
//                               ),

//                     //Image.asset('assets/images/imageLg.png',height:screenHeight,fit: BoxFit.cover,),
//                     Visibility(
//                       visible: _isVisible_beforeRec,
//                       child: Positioned(
//                         left: 20,
//                         top: 40,
//                         child: Align(
//                           // alignment: Alignment.topLeft,
//                           child: SizedBox(
//                             width: 70,
//                             height: 70,
//                             child: IconButton(
//                               onPressed: () async {
//                                 var data = await AppData.getStoredData(
//                                     'giftRecipients');
//                                 var pageData = jsonDecode(data);
//                                 List recipients = [];
//                                 for (var recipient in pageData) {
//                                   recipients.add({
//                                     "srno": recipient['srno'],
//                                     "name": recipient['name'],
//                                     "email": recipient['email'],
//                                     "phone": recipient['phone']
//                                   });
//                                 }

//                                 String amount =
//                                     await AppData.getStoredData('giftAmount');
//                                 int selectedAmount = int.parse(amount);

//                                 var dataR =
//                                     await AppData.getStoredData('giftDressUp');
//                                 pageData = jsonDecode(dataR);
//                                 List dressUps = [];
//                                 for (var item in pageData) {
//                                   dressUps.add({
//                                     "id": item["id"],
//                                     "name": item['name'],
//                                     "price": item['amount']
//                                   });
//                                 }

//                                 List DeliverTo = [];
//                                 var dataA = await AppData.getStoredData(
//                                     'giftDeliverTo');
//                                 if (dataA.toString() == '[{}]') {
//                                   DeliverTo.add({
//                                     "name": "",
//                                     "address": "",
//                                     "city": "",
//                                     "state": "",
//                                     "zip": ""
//                                   });
//                                 } else {
//                                   pageData = jsonDecode(dataA);
//                                   for (var item in pageData) {
//                                     DeliverTo.add({
//                                       "name": item['name'],
//                                       "address": item['address'],
//                                       "city": item['city'],
//                                       "state": item['state'],
//                                       "zip": item['zip']
//                                     });
//                                   }
//                                 }

//                                 DateTime? _selectedDay;
//                                 var thisSelectedDate =
//                                     await AppData.getStoredData('giftDate');
//                                 _selectedDay = DateTime.parse(thisSelectedDate);

//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => RecordPVM(
//                                           Recipients: recipients,
//                                           SelectedAmount: selectedAmount,
//                                           DressUpStatus: dressUps,
//                                           DeliverTo: DeliverTo,
//                                           SelectedDay: _selectedDay),
//                                     ));
//                               },
//                               icon: Image.asset(
//                                 'assets/images/closeLg.png',
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Ellipse icon
//                     Visibility(
//                       visible: _isVisible_ellipse,
//                       child: Positioned.fill(
//                         bottom: 60,
//                         child: Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 500,
//                             height: 100,
//                             child: IconButton(
//                               onPressed: () {
//                                 showReadyState_Active();
//                               },
//                               icon: Stack(
//                                 children: [
//                                   Image.asset(
//                                     'assets/images/ellipse.png',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Ellipse icon
//                     Visibility(
//                       visible: _isVisible_endEllipse,
//                       child: Positioned.fill(
//                         bottom: 60,
//                         child: Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 500,
//                             height: 100,
//                             child: IconButton(
//                               onPressed: () {
//                                 State_RecordingEnd();
//                               },
//                               icon: Stack(
//                                 children: [
//                                   Image.asset(
//                                       'assets/images/ellipse-record.png'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Center Timer
//                     Visibility(
//                       visible: _isVisible_recPopup,
//                       child: Positioned(
//                         child: Container(
//                           width: screenWidth,
//                           height: screenHeight,
//                           color: Color(0x99202020),
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: screenWidth / 2.8,
//                                   height: screenWidth / 2.8,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(300),
//                                     color: Color(0x79202020),
//                                   ),
//                                   child: Center(
//                                     child: CountdownTimer(
//                                       onEnd: showReadyState_inActive,
//                                       endTime: readyRecording,
//                                       widgetBuilder: (_, time) {
//                                         return Text(
//                                           '${time?.sec}',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: screenWidth / 7),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ),
//                       ),
//                     ),

//                     //Recording Timer
//                     Visibility(
//                       visible: _isVisible_recordTime,
//                       child: Positioned.fill(
//                         bottom: 20,
//                         child: Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             width: 90,
//                             decoration: BoxDecoration(
//                                 color: Color(0x60000000),
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 0),
//                               child: CountdownTimer(
//                                 onEnd: recording_Stop,
//                                 endTime: endTime,
//                                 widgetBuilder: (_, time) {
//                                   if (time == null) {
//                                     _recordVideo();
//                                   }
//                                   return Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text(
//                                         // '${time.min} : ' if time is more than 1minute
//                                         '00',
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       Text(
//                                         ':',
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       Text(
//                                         '${time?.sec}',
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Right-top Options
//                     Visibility(
//                       visible: _isVisible_beforeRec,
//                       child: Positioned(
//                         right: 20,
//                         top: 50,
//                         child: Align(
//                           // alignment: Alignment.topRight,
//                           child: SizedBox(
//                             width: 55,
//                             height: 55,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Color(0x20051C48),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 3, horizontal: 0),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     /*
//                                     IconButton(
//                                       onPressed: () {
//                                         Navigator.pushReplacementNamed(
//                                             context, 'record-video/filters');
//                                       },
//                                       icon: Image.asset('assets/images/ios-color-filter.png',),
//                                     ),
//                                     IconButton(
//                                       onPressed: () {},
//                                       icon: Image.asset('assets/images/subtraction.png',),
//                                     ),
//                                      */
//                                     IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           _isFrontCamera = !_isFrontCamera;
//                                           loadCamera();
//                                         });

//                                         print('change camera');
//                                       },
//                                       icon: Image.asset(
//                                         'assets/images/feather-rotate.png',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
