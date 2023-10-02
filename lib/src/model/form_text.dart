// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

class FormItem {
  final String? text;
  final String? label;
  final String? hintText;
  final String? type;
  final String? drop;
  final String? value2;
  final bool? required;

  FormItem({
    this.text,
    this.label,
    this.hintText,
    this.type,
    this.drop,
    this.value2,
    this.required = true,
  });

  factory FormItem.fromJson(Map<String, dynamic> json) {
    return FormItem(
      text: json['text'],
      label: json['label'],
      hintText: json['hintText'],
      type: json['type'],
      drop: json['drop'],
      value2: json['value2'],
      required: json['required'],
    );
  }
}

class FormImage {
  final String? image;

  FormImage({
    this.image,
  });

  factory FormImage.fromJson(Map<String, dynamic> json) {
    return FormImage(
      image: json['image'],
    );
  }
}

class FormFile {
  final String? url;
  final String? path;

  FormFile({
    this.url,
    this.path,
  });

  factory FormFile.fromJson(Map<String, dynamic> json) {
    return FormFile(
      url: json['url'],
      path: json['path'],
    );
  }
}

class FormService {
  final String? image;
  final String? title;

  FormService({
    this.image,
    this.title,
  });

  factory FormService.fromJson(Map<String, dynamic> json) {
    return FormService(
      image: json['image'],
      title: json['title'],
    );
  }
}

class FormData {
  final String? key;
  final String? urlVideo;
  final List<FormItem>? value;
  final List<FormImage>? valueImage;
  final List<FormFile>? valueFiles;
  final List<FormService>? valueServices;

  FormData({
    this.key,
    this.value,
    this.urlVideo,
    this.valueImage,
    this.valueFiles,
    this.valueServices,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? valueJson = json['value'];
    final List<FormItem>? formItems = valueJson?.map((itemJson) {
      return FormItem.fromJson(itemJson);
    }).toList();

    final List<dynamic>? valueJson1 = json['valueImage'];
    final List<FormImage>? formItems1 = valueJson1?.map((itemJson) {
      return FormImage.fromJson(itemJson);
    }).toList();

    final List<dynamic>? valueJson2 = json['valueFiles'];
    final List<FormFile>? formItems2 = valueJson2?.map((itemJson) {
      return FormFile.fromJson(itemJson);
    }).toList();

    final List<dynamic>? valueJson3 = json['valueServices'];
    final List<FormService>? formItems3 = valueJson3?.map((itemJson) {
      return FormService.fromJson(itemJson);
    }).toList();

    return FormData(
      key: json['key'],
      urlVideo: json['urlVideo'] ?? '',
      value: formItems,
      valueImage: formItems1,
      valueFiles: formItems2,
      valueServices: formItems3,
    );
  }
}
