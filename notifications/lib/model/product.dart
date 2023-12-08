
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
part 'product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  const Product({
    required this.userName,
    required this.timePresent,
    this.isError,
  });
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

 @JsonKey(name: 'user_name')
  final String userName;
@JsonKey(name: 'time_present')
  final DateTime timePresent;
  @JsonKey(name: 'is_error')
  final double? isError;
  

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [
       userName,
       timePresent,
       isError
      ];
}


List<Product> parseProducts(List<dynamic> parsed) {
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}