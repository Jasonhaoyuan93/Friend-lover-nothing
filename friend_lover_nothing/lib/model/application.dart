import 'dart:core';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/model/event.dart';
import 'package:json_annotation/json_annotation.dart';
part 'application.g.dart';

//model for API call- Application
@JsonSerializable()
class Application {
  Event? event;
  Account account;
  String? cloudVideoFileLocation;
  bool approved;
  bool closed;

  Application(
      {this.event,
      required this.account,
      this.cloudVideoFileLocation,
      this.approved = false,
      this.closed = false});

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}
