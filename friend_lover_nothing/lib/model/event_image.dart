import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
part 'event_image.g.dart';

//model for API call- Account
@JsonSerializable()
class EventImage {
  int? id;
  String? imageLocation;
  String imageDescription;

  EventImage({this.id, this.imageLocation, this.imageDescription = ""});

  factory EventImage.fromJson(Map<String, dynamic> json) =>
      _$EventImageFromJson(json);

  Map<String, dynamic> toJson() => _$EventImageToJson(this);
}
