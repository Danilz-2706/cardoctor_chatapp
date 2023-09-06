class FormItem {
  final String? text;
  final String? label;
  final String? hintText;
  final String? type;
  final String? drop;
  final String? value2;

  FormItem({
    this.text,
    this.label,
    this.hintText,
    this.type,
    this.drop,
    this.value2,
  });

  factory FormItem.fromJson(Map<String, dynamic> json) {
    return FormItem(
      text: json['text'],
      label: json['label'],
      hintText: json['hintText'],
      type: json['type'],
      drop: json['drop'],
      value2: json['value2'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'label': label,
      'hintText': hintText,
      'type': type,
      'drop': drop,
      'value2': value2,
    };
  }

  factory FormItem.fromMap(Map<String, dynamic> map) {
    return FormItem(
      text: map['text'] != null ? map['text'] as String : null,
      label: map['label'] != null ? map['label'] as String : null,
      hintText: map['hintText'] != null ? map['hintText'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      drop: map['drop'] != null ? map['drop'] as String : null,
      value2: map['value2'] != null ? map['value2'] as String : null,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
    };
  }

  factory FormImage.fromMap(Map<String, dynamic> map) {
    return FormImage(
      image: map['image'] != null ? map['image'] as String : null,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'path': path,
    };
  }
}

class FormData {
  final String? key;
  final List<FormItem>? value;
  final List<FormImage>? valueImage;
  final List<FormFile>? valueFiles;

  FormData({
    this.key,
    this.value,
    this.valueImage,
    this.valueFiles,
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

    return FormData(
      key: json['key'],
      value: formItems,
      valueImage: formItems1,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'value': value?.map((x) => x?.toMap()).toList(),
      'valueImage': valueImage?.map((x) => x?.toMap()).toList(),
      'valueFiles': valueFiles?.map((x) => x?.toMap()).toList(),
    };
  }
}
