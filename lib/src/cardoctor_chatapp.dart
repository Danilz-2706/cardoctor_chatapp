class ChatAppCarDoctorUtilOption {
  final String apiKey;
  final String apiSecret;
  final String cluseterID;
  final String getNotifySelf;
  final String groupName;
  final String idUserFrom;
  final List<dynamic> historyChat;
  ChatAppCarDoctorUtilOption({
    required this.apiKey,
    required this.apiSecret,
    required this.cluseterID,
    required this.getNotifySelf,
    required this.groupName,
    required this.idUserFrom,
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
