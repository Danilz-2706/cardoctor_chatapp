// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse(
      id: json['id'] as int?,
      groupId: json['groupId'] as int?,
      userId: json['userId'] as int?,
      profileName: json['profileName'] as String?,
      originalMessage: json['originalMessage'] as String?,
      filteredMessage: json['filteredMessage'] as String?,
      attachmentType: json['attachmentType'] as String?,
      attachment: json['attachment'] as String?,
      linkPreview: json['linkPreview'] as String?,
      username: json['username'] as String?,
      groupName: json['groupName'] as String?,
      type: json['type'] as int?,
      createdAtStr: json['createdAtStr'] as String?,
      updatedAtStr: json['updatedAtStr'] as String?,
    );

Map<String, dynamic> _$SendMessageResponseToJson(
        SendMessageResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'profileName': instance.profileName,
      'originalMessage': instance.originalMessage,
      'filteredMessage': instance.filteredMessage,
      'attachmentType': instance.attachmentType,
      'attachment': instance.attachment,
      'linkPreview': instance.linkPreview,
      'username': instance.username,
      'groupName': instance.groupName,
      'type': instance.type,
      'createdAtStr': instance.createdAtStr,
      'updatedAtStr': instance.updatedAtStr,
    };
