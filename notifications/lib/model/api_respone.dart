import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_respone.g.dart';

@JsonSerializable()
class ApiResponse extends Equatable {
  const ApiResponse({
    // required this.code,
    this.status = '',
    this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);

  // final int code;
  final String status;
  final String? message;
  final dynamic data;

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);

  @override
  List<Object?> get props => [status, message, data];
}

ApiResponse parseApiResponse(Map<String, dynamic> parsed) {
  return ApiResponse.fromJson(parsed);
}

extension ApiResponseValid on ApiResponse {
  void check() {
    if (status != 'SUCCESS') {
      throw Exception(message?.isNotEmpty == true ? message : 'Sonmethings error!');
    }
  }
}