// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';

// class GalleryDownloader {
//   static void saveNetworkVideoInGallery(
//     BuildContext context,
//     String url,
//     bool isFurtherOpenFile,
//     String fileName,
//     GlobalKey keyloader,
//   ) async {
//     String path = url + "&ext=.mp4";
//     Dialogs.showLoadingDialog(context, keyloader);
//     GallerySaver.saveVideo(path).then((success) async {
//       if (success == true) {
//         Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();

//         // Fiberchat.toast("$fileName  " + getTranslated(context, "folder"));
//       } else {
//         Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
//         // Fiberchat.toast(getTranslated(context, 'failedtodownload'));
//       }
//     }).catchError((err) {
//       Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
//       // Fiberchat.toast(err.toString());
//     });
//   }

//   static void saveNetworkImage(
//     BuildContext context,
//     String url,
//     bool isFurtherOpenFile,
//     String fileName,
//     GlobalKey keyloader,
//   ) async {
//     // String path =
//     //     'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';

//     String path = url + "&ext=.jpg";
//     Dialogs.showLoadingDialog(context, keyloader);
//     GallerySaver.saveImage(path, toDcim: true).then((success) async {
//       if (success == true) {
//         Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
//         // Fiberchat.toast(fileName == ""
//         //     ? getTranslated(context, "folder")
//         //     : "$fileName  " + getTranslated(context, "folder"));
//       } else {
//         // Fiberchat.toast(getTranslated(context, 'failedtodownload'));
//         Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
//       }
//     }).catchError((err) {
//       Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
//       // Fiberchat.toast(err.toString());
//     });
//   }
// }

// class Dialogs {
//   static Future<void> showLoadingDialog(
//       BuildContext context, GlobalKey key) async {
//     return showDialog<void>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return new WillPopScope(
//               onWillPop: () async => false,
//               child: SimpleDialog(
//                   key: key,
//                   backgroundColor: Color(0xff202e35),
//                   children: <Widget>[
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(18.0),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 width: 18,
//                               ),
//                               CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Color.fromARGB(255, 249, 115, 58),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 23,
//                               ),
//                               Text(
//                                 "Downloading...",
//                                 style: TextStyle(
//                                   color: Color(0xff202e35),
//                                 ),
//                               )
//                             ]),
//                       ),
//                     )
//                   ]));
//         });
//   }
// }
