import 'package:json_annotation/json_annotation.dart';

part 'send_message_response.g.dart';

@JsonSerializable()
class SendMessageResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'groupId')
  int? groupId;

  @JsonKey(name: 'userId')
  int? userId;

  @JsonKey(name: 'profileName')
  String? profileName;

  @JsonKey(name: 'originalMessage')
  String? originalMessage;

  @JsonKey(name: 'filteredMessage')
  String? filteredMessage;

  @JsonKey(name: 'attachmentType')
  String? attachmentType;

  @JsonKey(name: 'attachment')
  String? attachment;

  @JsonKey(name: 'linkPreview')
  String? linkPreview;

  @JsonKey(name: 'username')
  String? username;

  @JsonKey(name: 'groupName')
  String? groupName;

  @JsonKey(name: 'type')
  int? type;

  @JsonKey(name: 'createdAtStr')
  String? createdAtStr;

  @JsonKey(name: 'updatedAtStr')
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

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}
