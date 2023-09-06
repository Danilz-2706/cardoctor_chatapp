import 'package:json_annotation/json_annotation.dart';

part 'send_message_request.g.dart';

@JsonSerializable()
class SendMessageRequest {
  @JsonKey(name: 'originalMessage')
  String? originalMessage;

  @JsonKey(name: 'attachmentType')
  String? attachmentType;

  @JsonKey(name: 'linkPreview')
  String? linkPreview;

  @JsonKey(name: 'groupName')
  String? groupName;

  @JsonKey(name: 'username')
  String? username;

  @JsonKey(name: 'type')
  int? type;

  SendMessageRequest({
    this.originalMessage,
    this.attachmentType,
    this.linkPreview,
    this.groupName,
    this.username,
    this.type,
  });

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}
