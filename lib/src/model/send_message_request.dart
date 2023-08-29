class SendMessageRequest {
  String? originalMessage;

  String? attachmentType;

  String? linkPreview;

  String? groupName;

  String? username;
  int? type;

  SendMessageRequest({
    this.originalMessage,
    this.attachmentType,
    this.linkPreview,
    this.groupName,
    this.username,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'originalMessage': originalMessage,
      'attachmentType': attachmentType,
      'linkPreview': linkPreview,
      'groupName': groupName,
      'username': username,
      'type': type,
    };
  }

  factory SendMessageRequest.fromMap(Map<String, dynamic> map) {
    return SendMessageRequest(
      originalMessage: map['originalMessage'] != null
          ? map['originalMessage'] as String
          : null,
      attachmentType: map['attachmentType'] != null
          ? map['attachmentType'] as String
          : null,
      linkPreview:
          map['linkPreview'] != null ? map['linkPreview'] as String : null,
      groupName: map['groupName'] != null ? map['groupName'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      type: map['type'] != null ? map['type'] as int : null,
    );
  }
}
