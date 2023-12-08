import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:notifications/model/api_respone.dart';
import 'package:notifications/model/product.dart';


class ProductRespository {
  ProductRespository({required this.client});
  Dio client;
  Future<List<Product>> getProducts({CancelToken? cancelToken}) async {
    final response = await client.get('http://192.168.1.3:3000/all_product', cancelToken: cancelToken);
    ApiResponse apiResponse = await compute<Map<String, dynamic>, ApiResponse>(parseApiResponse, response.data as Map<String, dynamic>);
    apiResponse.check();
    return compute<List<dynamic>, List<Product>>(parseProducts, apiResponse.data);
  }
}