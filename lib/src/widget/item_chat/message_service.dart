import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/form_text.dart';
import '../../model/send_message_response.dart';
import '../../page/image_chat/image_chat_screen.dart';

class MessageService extends StatelessWidget {
  const MessageService({
    Key? key,
    required this.listService,
    required this.data,
    required this.isLeft,
  }) : super(key: key);

  final List<FormService> listService;
  final SendMessageResponse data;
  final bool isLeft;
  final String noImageAvailable =
      "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

  @override
  Widget build(BuildContext context) {
    var key = UniqueKey().toString();
    print('&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(listService[0].title);
    print(listService[1].title);
    print(listService[2].title);
    print(listService[0].image);
    print(listService[1].image);
    print(listService[2].image);
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLeft
              ? MediaQuery.of(context).size.width - 160
              : MediaQuery.of(context).size.width - 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: List.generate(
            listService.length,
            (index) {
              return Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 15,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 39,
                      width: 39,
                      child: CachedNetworkImage(
                        imageUrl: listService[index].image ?? noImageAvailable,
                        placeholder: (context, url) => SizedBox(
                          width: 39,
                          height: 39,
                          child: Image.network(noImageAvailable,
                              fit: BoxFit.cover),
                        ),
                        errorWidget: (context, url, err) => SizedBox(
                          width: 39,
                          height: 39,
                          child: Image.network(noImageAvailable,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        listService[index].title ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(10, 11, 9, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
