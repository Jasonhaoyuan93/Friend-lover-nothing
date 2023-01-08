// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventImage _$EventImageFromJson(Map<String, dynamic> json) => EventImage(
      id: json['id'] as int?,
      imageLocation: json['imageLocation'] as String?,
      imageDescription: json['imageDescription'] as String? ?? "",
    );

Map<String, dynamic> _$EventImageToJson(EventImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageLocation': instance.imageLocation,
      'imageDescription': instance.imageDescription,
    };
