import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../model/form_text.dart';
import '../../utils/DownloadManager/download_all_file_type.dart';

class MessageFile extends StatefulWidget {
  const MessageFile({
    Key? key,
    required this.listFiles,
    required this.isLeft,
    this.local = false,
  }) : super(key: key);

  final List<FormFile> listFiles;
  final bool isLeft;
  final bool local;

  @override
  State<MessageFile> createState() => _MessageFileState();
}

class _MessageFileState extends State<MessageFile> {
  bool process = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              widget.isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: List.generate(
            widget.listFiles.length,
            (index) {
              return InkWell(
                onTap: widget.local
                    ? null
                    : process == true
                        ? () {}
                        : () async {
                            await MobileDownloadService().download(
                              url: widget.listFiles[index].url!,
                              fileName: basename(widget.listFiles[index].path!),
                              context: this.context,
                              isOpenAfterDownload: true,
                              downloading: (p0) {
                                setState(() {
                                  process = p0;
                                });
                              },
                            );
                          },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(243, 243, 243, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: widget.isLeft
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (process == true)
                        const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        ),
                      if (process == false)
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
                            basename(widget.listFiles[index].path!).toString(),
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
    );
  }
}
