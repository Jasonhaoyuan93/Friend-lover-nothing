// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      event: json['event'] == null
          ? null
          : Event.fromJson(json['event'] as Map<String, dynamic>),
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      cloudVideoFileLocation: json['cloudVideoFileLocation'] as String?,
      approved: json['approved'] as bool? ?? false,
      closed: json['closed'] as bool? ?? false,
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'event': instance.event,
      'account': instance.account,
      'cloudVideoFileLocation': instance.cloudVideoFileLocation,
      'approved': instance.approved,
      'closed': instance.closed,
    };
