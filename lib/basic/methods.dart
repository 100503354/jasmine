import 'dart:convert';

import 'package:flutter/services.dart';

import 'entities.dart';
export 'entities.dart';

const methods = Methods._();

class Methods {
  const Methods._();

  static const _channel = MethodChannel("methods");

  Future<String> _invoke(String method, dynamic params) async {
    String resp = await _channel.invokeMethod(
        "invoke",
        jsonEncode({
          "method": method,
          "params": params is String ? params : jsonEncode(params),
        }));
    var response = _Response.fromJson(jsonDecode(resp));
    if (response.errorMessage.isNotEmpty) {
      throw StateError(response.errorMessage);
    }
    return response.responseData;
  }

  Future<String> loadProperty(String propertyKey) {
    return _invoke("load_property", propertyKey);
  }

  Future<ComicsResponse> comics(String slug, SortBy sortBy, int page) async {
    final rsp = await _invoke("comics", {
      "categories_slug": slug,
      "sort_by": sortBy.value,
      "page": page,
    });
    return ComicsResponse.fromJson(jsonDecode(rsp));
  }

  Future<CategoriesResponse> categories() async {
    return CategoriesResponse.fromJson(
        jsonDecode(await _invoke("categories", "")));
  }

  Future<String> jm3x4Cover(int comicId) {
    return _invoke("jm3x4_cover", comicId);
  }

  Future saveImageFileToGallery(String path) {
    return _channel.invokeMethod("saveImageFileToGallery", path);
  }

  Future saveProperty(String key, String v) {
    return _invoke("save_property", {"k": key, "v": v});
  }
}

class _Response {
  late String errorMessage;
  late String responseData;

  _Response.fromJson(Map json) {
    errorMessage = json["error_message"];
    responseData = json["response_data"];
  }
}
