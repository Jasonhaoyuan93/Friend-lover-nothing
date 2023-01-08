import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
part 'account.g.dart';

//model for API call- Account
@JsonSerializable()
class Account {
  String id;
  String firstName;
  String lastName;
  int? age;
  String? link;
  String? description;
  String email;
  String? phone;
  String? gender;
  String? profileImageLocation;
  String? interest1;
  String? interest2;
  String? interest3;

  Account(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.gender,
      this.age,
      this.link,
      this.description,
      required this.email,
      this.phone,
      this.profileImageLocation,
      this.interest1,
      this.interest2,
      this.interest3});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Account.clone(Account account)
      : this(
            id: account.id,
            firstName: account.firstName,
            lastName: account.lastName,
            gender: account.gender,
            age: account.age,
            link: account.link,
            description: account.description,
            email: account.email,
            phone: account.phone,
            profileImageLocation: account.profileImageLocation,
            interest1: account.interest1,
            interest2: account.interest2,
            interest3: account.interest3);
}
