import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile {
  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName);
    if (file == null) return;
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String? fileName) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$fileName');
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
