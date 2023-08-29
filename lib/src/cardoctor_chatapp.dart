import 'package:cardoctor_chatapp/cardoctor_chatapp.dart';
import 'package:flutter/material.dart';

import 'utils/navigation_utils.dart';

class ChatAppCarDoctorUtilOption {
  final String apiKey;
  final String apiSecret;
  final String cluseterID;
  final String getNotifySelf;
  final String groupName;
  final List<dynamic> historyChat;
  ChatAppCarDoctorUtilOption({
    required this.apiKey,
    required this.apiSecret,
    required this.cluseterID,
    required this.getNotifySelf,
    required this.groupName,
    required this.historyChat,
  });
}

// class ChatAppCarDoctorUtil {
//   final ChatAppCarDoctorUtilOption option;
//   final Function(dynamic) press;

//   ChatAppCarDoctorUtil(this.option, this.press);

//   Future open(BuildContext context) {
//     return NavigationUtils.rootNavigatePageWithArguments(
//       context,
//       ChatDetailScreen(data: option),
//     );
//   }
// }
