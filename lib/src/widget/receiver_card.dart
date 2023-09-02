import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardoctor_chatapp/src/widget/text_field_form.dart';
import 'package:cardoctor_chatapp/src/widget/title_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../model/form_text.dart';
import '../model/send_message_response.dart';
import '../page/contains.dart';
import 'label_drop_down.dart';

class ReceiverCard extends StatefulWidget {
  final SendMessageResponse data;
  final bool onlyOnePerson;
  final List<String> listImages;
  final List<FormFile> listFiles;
  final List<FormItem> listForm;

  const ReceiverCard({
    Key? key,
    required this.onlyOnePerson,
    required this.data,
    required this.listImages,
    required this.listFiles,
    required this.listForm,
  }) : super(key: key);

  @override
  State<ReceiverCard> createState() => _ReceiverCardState();
}

class _ReceiverCardState extends State<ReceiverCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = 45.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 28,
          width: 28,
          child: widget.onlyOnePerson
              ? const SizedBox()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.high,
                    imageUrl: '',
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => Image.asset(
                      'assets/imgs/avatar.png',
                      package: Consts.packageName,
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                    ),
                    errorWidget: (context, url, _) => Image.asset(
                      'assets/imgs/avatar.png',
                      package: Consts.packageName,
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 8),
        if (widget.listForm.isEmpty &&
            widget.listImages.isEmpty &&
            widget.listFiles.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 160),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kWhiteColors,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.data.originalMessage ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: kTextBlackColors,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
        if (widget.listForm.isNotEmpty)
          Align(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 160),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    widget.listForm.length,
                    (index) {
                      if (widget.listForm[index].type == 'title') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TitleForm(listForm: widget.listForm[index]),
                        );
                      }
                      if (widget.listForm[index].type == 'dropdown') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: LabelDropDownForm(
                              listForm: widget.listForm[index]),
                        );
                      }
                      if (widget.listForm[index].type == 'textfield') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child:
                              TextFieldForm(listForm: widget.listForm[index]),
                        );
                      }
                      if (widget.listForm[index].type == 'image') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: widget.listForm[index].text ?? '',
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
          ),
        if (widget.listImages.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 100),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.listImages.length,
                    (index) {
                      return CachedNetworkImage(
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
                        imageUrl: widget.listImages[index],
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
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        if (widget.listFiles.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 160),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.listFiles.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.insert_drive_file_rounded,
                                color: Color.fromRGBO(107, 109, 108, 1),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    basename(widget.listFiles[index].path!)
                                        .toString(),
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(10, 11, 9, 1)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        Text(
          widget.data.createdAtStr != null
              ? DateFormat('HH:mm')
                  .format(DateTime.parse(widget.data.createdAtStr!))
              : DateFormat('HH:mm').format(DateTime.now()),
          style: const TextStyle(
              color: kTextGreyColors,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
