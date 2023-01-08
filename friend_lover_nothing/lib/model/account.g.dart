// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      link: json['link'] as String?,
      description: json['description'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      profileImageLocation: json['profileImageLocation'] as String?,
      interest1: json['interest1'] as String?,
      interest2: json['interest2'] as String?,
      interest3: json['interest3'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'link': instance.link,
      'description': instance.description,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'profileImageLocation': instance.profileImageLocation,
      'interest1': instance.interest1,
      'interest2': instance.interest2,
      'interest3': instance.interest3,
    };
