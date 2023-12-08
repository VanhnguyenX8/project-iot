// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      userName: json['user_name'] as String,
      timePresent: DateTime.parse(json['time_present'] as String),
      isError: (json['is_error'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'user_name': instance.userName,
      'time_present': instance.timePresent.toIso8601String(),
      'is_error': instance.isError,
    };
