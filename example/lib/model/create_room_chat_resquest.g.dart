// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_room_chat_resquest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRoomChatResquest _$CreateRoomChatResquestFromJson(
        Map<String, dynamic> json) =>
    CreateRoomChatResquest(
      convType: json['convType'] as String?,
      driverId: json['driverId'] as String?,
      requestTicketId: json['requestTicketId'] as String?,
      operatorId: json['operatorId'] as String?,
      expertId: json['expertId'] as String?,
      garageId: json['garageId'] as String?,
    );

Map<String, dynamic> _$CreateRoomChatResquestToJson(
        CreateRoomChatResquest instance) =>
    <String, dynamic>{
      'convType': instance.convType,
      'driverId': instance.driverId,
      'requestTicketId': instance.requestTicketId,
      'operatorId': instance.operatorId,
      'expertId': instance.expertId,
      'garageId': instance.garageId,
    };
