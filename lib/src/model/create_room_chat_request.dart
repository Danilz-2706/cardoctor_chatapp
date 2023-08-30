// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'convType': convType,
      'driverId': driverId,
      'requestTicketId': requestTicketId,
      'operatorId': operatorId,
      'expertId': expertId,
      'garageId': garageId,
    };
  }

  factory CreateRoomChatResquest.fromMap(Map<String, dynamic> map) {
    return CreateRoomChatResquest(
      convType: map['convType'] != null ? map['convType'] as String : null,
      driverId: map['driverId'] != null ? map['driverId'] as String : null,
      requestTicketId: map['requestTicketId'] != null ? map['requestTicketId'] as String : null,
      operatorId: map['operatorId'] != null ? map['operatorId'] as String : null,
      expertId: map['expertId'] != null ? map['expertId'] as String : null,
      garageId: map['garageId'] != null ? map['garageId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateRoomChatResquest.fromJson(String source) => CreateRoomChatResquest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreateRoomChatResquest(convType: $convType, driverId: $driverId, requestTicketId: $requestTicketId, operatorId: $operatorId, expertId: $expertId, garageId: $garageId)';
  }
}
