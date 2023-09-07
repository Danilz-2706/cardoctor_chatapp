import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../widget/Common/open_result.dart';

class OpenFile {
  static const MethodChannel _channel = const MethodChannel('open_file');

  OpenFile._();

  static Future<OpenResult> open(String? filePath,
      {String? type,
      String? uti,
      String linuxDesktopName = "xdg",
      bool linuxByProcess = false,
      Uint8List? webData}) async {
    assert(filePath != null);

    Map<String, String?> map = {
      "file_path": filePath!,
      "type": type,
      "uti": uti,
    };
    final _result = await _channel.invokeMethod('open_file', map);
    final resultMap = json.decode(_result) as Map<String, dynamic>;
    return OpenResult.fromJson(resultMap);
  }
}
