// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class 
SendMessageResponse {
  int? id;

  int? groupId;

  int? userId;

  String? profileName;

  String? originalMessage;

  String? filteredMessage;

  String? attachmentType;

  String? attachment;

  String? linkPreview;
  String? username;

  String? groupName;

  int? type;

  String? createdAtStr;

  String? updatedAtStr;

  SendMessageResponse({
    this.id,
    this.groupId,
    this.userId,
    this.profileName,
    this.originalMessage,
    this.filteredMessage,
    this.attachmentType,
    this.attachment,
    this.linkPreview,
    this.username,
    this.groupName,
    this.type,
    this.createdAtStr,
    this.updatedAtStr,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'groupId': groupId,
      'userId': userId,
      'profileName': profileName,
      'originalMessage': originalMessage,
      'filteredMessage': filteredMessage,
      'attachmentType': attachmentType,
      'attachment': attachment,
      'linkPreview': linkPreview,
      'username': username,
      'groupName': groupName,
      'type': type,
      'createdAtStr': createdAtStr,
      'updatedAtStr': updatedAtStr,
    };
  }

  factory SendMessageResponse.fromMap(Map<String, dynamic> map) {
    return SendMessageResponse(
      id: map['id'] != null ? map['id'] as int : null,
      groupId: map['groupId'] != null ? map['groupId'] as int : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      profileName:
          map['profileName'] != null ? map['profileName'] as String : null,
      originalMessage: map['originalMessage'] != null
          ? map['originalMessage'] as String
          : null,
      filteredMessage: map['filteredMessage'] != null
          ? map['filteredMessage'] as String
          : null,
      attachmentType: map['attachmentType'] != null
          ? map['attachmentType'] as String
          : null,
      attachment:
          map['attachment'] != null ? map['attachment'] as String : null,
      linkPreview:
          map['linkPreview'] != null ? map['linkPreview'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      groupName: map['groupName'] != null ? map['groupName'] as String : null,
      type: map['type'] != null ? map['type'] as int : null,
      createdAtStr:
          map['createdAtStr'] != null ? map['createdAtStr'] as String : null,
      updatedAtStr:
          map['updatedAtStr'] != null ? map['updatedAtStr'] as String : null,
    );
  }
}
