class RemainingMap {
  var record_remaining;

  RemainingMap(
    this.record_remaining,
  );

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
