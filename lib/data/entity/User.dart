import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  int id;
  int accountId;
  String userName;
  String password;
  String status;
  String name;
  String phoneNumber;
  String? address;
  String? city;
  String? country;
  String avatar;

  User(
      this.id,
      this.accountId,
      this.userName,
      this.password,
      this.status,
      this.name,
      this.phoneNumber,
      this.address,
      this.city,
      this.country,
      this.avatar);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{id: $id, accountId: $accountId, userName: $userName, password: $password, status: $status, name: $name, phoneNumber: $phoneNumber, address: $address, city: $city, country: $country, avatar: $avatar}';
  }
}