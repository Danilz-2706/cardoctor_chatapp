import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/form_text.dart';
import '../../page/image_chat/image_chat_screen.dart';
import '../label_drop_down.dart';
import '../text_field_form.dart';
import '../title_form.dart';

class MessageForm extends StatelessWidget {
  final bool isLeft;
  final List<FormItem> data;
  const MessageForm({
    Key? key,
    required this.data,
    required this.isLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var key = UniqueKey().toString();

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLeft
              ? MediaQuery.of(context).size.width - 160
              : MediaQuery.of(context).size.width - 100,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              data.length,
              (index) {
                if (data[index].type == 'title') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TitleForm(listForm: data[index]),
                  );
                }
                if (data[index].type == 'dropdown') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: LabelDropDownForm(listForm: data[index]),
                  );
                }
                if (data[index].type == 'textfield') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFieldForm(listForm: data[index]),
                  );
                }
                if (data[index].type == 'image') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageChatScreen(
                              id: key,
                              url: data[index].text ?? '',
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: key,
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl: data[index].text ?? '',
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
