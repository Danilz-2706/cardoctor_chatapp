import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../widget/search_list_simple_item_popup.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../contains.dart';

var list = [
  {
    "avatar": "assets/Group.svg",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": true,
  },
  {
    "avatar": "assets/Group.svg",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": true,
  },
  {
    "avatar": "assets/Group.svg",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": false,
  },
  {
    "avatar": "assets/Group.svg",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": false,
  }
];

class ChatListScreen extends StatelessWidget {
  final String cluseterID;
  final String apiKey;
  final String apiSecret;
  final String user1Id;
  final String user2Id;
  final int getNotifySelf;
  final int getPresence;
  final String jwt;
  final PreferredSize? appBar;
  const ChatListScreen(
      {super.key,
      required this.cluseterID,
      required this.apiKey,
      required this.apiSecret,
      required this.user1Id,
      required this.user2Id,
      required this.getNotifySelf,
      required this.getPresence,
      required this.jwt,
      this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: kBgColors,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.only(left: 28, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 48,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              child: SearchListSimpleItemPopup<dynamic>(
                apiKey: apiKey,
                apiSecret: apiSecret,
                cluseterID: cluseterID,
                user1Id: '',
                user2Id: '',
                getNotifySelf: 1,
                getPresence: 1,
                jwt: '',
                listData: list,
                onSelect: (x) {
                  return x;
                },
                builder: (item) => item.brandModel ?? "",
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 20),
              child: Expanded(
                child: Column(
                  children: List.generate(
                    list.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(
                                apiKey: apiKey,
                                apiSecret: apiSecret,
                                cluseterID: cluseterID,
                                user1Id: '',
                                user2Id: '',
                                getNotifySelf: 1,
                                getPresence: 1,
                                jwt: '',
                                avatar: list[index]['avatar'].toString(),
                                name: list[index]['name'].toString(),
                              ),
                            ),
                          );
                        },
                        child: ChatItem(
                          avatar: 'assets/imgs/ic_gallary.png',
                          name: list[index]['name'].toString(),
                          lastMessage: list[index]['last_message'].toString(),
                          time: list[index]['time'].toString(),
                          read: list[index]['read']! as bool,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String avatar;
  final String name;
  final String lastMessage;
  final String time;
  final bool? read;
  const ChatItem({
    super.key,
    required this.avatar,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.read,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            avatar,
            height: 60,
            width: 60,
            package: Consts.packageName,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color.fromRGBO(10, 11, 9, 1),
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        if (read!)
                          Image.asset(
                            'assets/imgs/ic_check.png',
                            height: 12,
                            package: Consts.packageName,
                            fit: BoxFit.contain,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Color.fromRGBO(139, 141, 140, 1),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color.fromRGBO(139, 141, 140, 1),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
