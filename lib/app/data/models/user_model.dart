import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  UserModel({required this.id, required this.fullName});
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;
}
