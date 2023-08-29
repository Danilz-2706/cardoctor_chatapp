// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    SendMessageRequest(
      originalMessage: json['originalMessage'] as String?,
      attachmentType: json['attachmentType'] as String?,
      linkPreview: json['linkPreview'] as String?,
      groupName: json['groupName'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) =>
    <String, dynamic>{
      'originalMessage': instance.originalMessage,
      'attachmentType': instance.attachmentType,
      'linkPreview': instance.linkPreview,
      'groupName': instance.groupName,
      'username': instance.username,
    };
