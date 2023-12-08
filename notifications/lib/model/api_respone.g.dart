// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_respone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => ApiResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
