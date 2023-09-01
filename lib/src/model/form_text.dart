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

class FormData {
  final String? key;
  final List<FormItem>? value;
  final List<FormImage>? valueImage;

  FormData({
    this.key,
    this.value,
    this.valueImage,
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
}
