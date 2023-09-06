import 'package:json_annotation/json_annotation.dart';

part 'create_room_chat_resquest.g.dart';

@JsonSerializable()
class CreateRoomChatResquest {
  String? convType;
  String? driverId;
  String? requestTicketId;
  String? operatorId;
  String? expertId;
  String? garageId;

  CreateRoomChatResquest({
    this.convType,
    this.driverId,
    this.requestTicketId,
    this.operatorId,
    this.expertId,
    this.garageId,
  });

  factory CreateRoomChatResquest.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomChatResquestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateRoomChatResquestToJson(this);
}
