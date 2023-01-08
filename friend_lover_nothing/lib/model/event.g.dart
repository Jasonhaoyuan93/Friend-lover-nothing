// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as int?,
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      eventImages: (json['eventImages'] as List<dynamic>)
          .map((e) => EventImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList(),
      videoLocation: json['videoLocation'] as String?,
      closed: json['closed'] as bool? ?? false,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'account': instance.account,
      'eventImages': instance.eventImages,
      'applications': instance.applications,
      'videoLocation': instance.videoLocation,
      'closed': instance.closed,
    };
