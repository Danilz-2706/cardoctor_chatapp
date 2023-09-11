import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/send_message_response.dart';
import '../../page/image_chat/image_chat_screen.dart';

class MessageImage extends StatelessWidget {
  const MessageImage({
    Key? key,
    required this.listImages,
    required this.data,
    required this.isLeft,
  }) : super(key: key);

  final List<String> listImages;
  final SendMessageResponse data;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    var key = UniqueKey().toString();
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLeft
              ? MediaQuery.of(context).size.width - 100
              : MediaQuery.of(context).size.width - 100,
        ),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: List.generate(
              listImages.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageChatScreen(
                          id: key,
                          url: listImages[index],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Hero(
                        tag: key,
                        child: CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.4,
                          placeholder: (context, url) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Icon(Icons.error),
                          ),
                          imageUrl: listImages[index],
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [],
                                image: DecorationImage(
                                  onError: (exception, stackTrace) {},
                                  isAntiAlias: true,
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: isLeft ? 8 : null,
                        left: !isLeft ? 8 : null,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(
                            data.createdAtStr != null
                                ? DateFormat('HH:mm')
                                    .format(DateTime.parse(data.createdAtStr!))
                                : DateFormat('HH:mm').format(DateTime.now()),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(139, 141, 140, 1)),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
