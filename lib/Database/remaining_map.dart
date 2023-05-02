import 'package:cloud_firestore/cloud_firestore.dart';

class RemainingMap {
  var record_remaining;
  String? remainID;

  RemainingMap(
    this.record_remaining,
  );

  factory RemainingMap.fromJson(Map<String, dynamic> json) =>
      _incomeFromJson(json);

  factory RemainingMap.fromSnapshot(DocumentSnapshot snapshot) {
    final newSaving =
        RemainingMap.fromJson(snapshot.data() as Map<String, dynamic>);
    newSaving.remainID = snapshot.reference.id;
    return newSaving;
  }

  Map<String, dynamic> toJson() => _incomeToJson(this);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'record_remaining': record_remaining,
    };
    return map;
  }

  RemainingMap.fromMap(Map<String, dynamic> map) {
    record_remaining = map["record_remaining"];
  }
}

RemainingMap _incomeFromJson(Map<String, dynamic> json) {
  return RemainingMap(
    json['record_remaining'] as int,
  );
}

Map<String, dynamic> _incomeToJson(RemainingMap instance) => <String, dynamic>{
      'record_remaining': instance.record_remaining,
    };
