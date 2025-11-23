import 'package:uuid/uuid.dart';

class UuidConverter {
  static UuidValue fromJson(String uuidStr) {
    return UuidValue.fromString(uuidStr);
  }

  static String toJson(UuidValue uuidValue) {
    return uuidValue.toString();
  }
}