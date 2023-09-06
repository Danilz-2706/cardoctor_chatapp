// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateRoomChatResponse {
  String? convId;
  String? convName;
  String? convType;
  String? driverId;
  String? expertId;
  String? driverName;
  String? expertName;

  CreateRoomChatResponse({
    this.convId,
    this.convName,
    this.convType,
    this.driverId,
    this.expertId,
    this.driverName,
    this.expertName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'convId': convId,
      'convName': convName,
      'convType': convType,
      'driverId': driverId,
      'expertId': expertId,
      'driverName': driverName,
      'expertName': expertName,
    };
  }

  factory CreateRoomChatResponse.fromMap(Map<String, dynamic> map) {
    return CreateRoomChatResponse(
      convId: map['convId'] != null ? map['convId'] as String : null,
      convName: map['convName'] != null ? map['convName'] as String : null,
      convType: map['convType'] != null ? map['convType'] as String : null,
      driverId: map['driverId'] != null ? map['driverId'] as String : null,
      expertId: map['expertId'] != null ? map['expertId'] as String : null,
      driverName:
          map['driverName'] != null ? map['driverName'] as String : null,
      expertName:
          map['expertName'] != null ? map['expertName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateRoomChatResponse.fromJson(String source) =>
      CreateRoomChatResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
