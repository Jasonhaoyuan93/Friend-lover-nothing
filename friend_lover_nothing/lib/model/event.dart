import 'dart:core';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/model/application.dart';
import 'package:friend_lover_nothing/model/event_image.dart';
import 'package:json_annotation/json_annotation.dart';
part 'event.g.dart';

//model for API call- Account
@JsonSerializable()
class Event {
  int? id;
  Account account;
  List<EventImage> eventImages;
  List<Application>? applications;
  String? videoLocation;
  bool closed;

  Event(
      {this.id,
      required this.account,
      required this.eventImages,
      this.applications,
      this.videoLocation,
      this.closed = false});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
