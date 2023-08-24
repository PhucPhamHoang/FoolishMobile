// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['accountId'] as int,
      json['userName'] as String,
      json['status'] as String,
      json['name'] as String,
      json['phoneNumber'] as String,
      json['address'] as String?,
      json['city'] as String?,
      json['country'] as String?,
      json['avatar'] as String?,
      json['email'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'userName': instance.userName,
      'status': instance.status,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'avatar': instance.avatar,
      'email': instance.email,
    };
