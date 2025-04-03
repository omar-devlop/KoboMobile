import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class GeminiService {
  Dio? _dio;

  Future<Dio> _getDio() async {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: 'https://generativelanguage.googleapis.com',
        ),
      );
      _dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut
        ..options.validateStatus = (status) {
          return true;
        };
      _dio?.options.headers = {
        // 'key': 'AIzaSyCauyBI0vPC_4qKsM7hF26jHFnOyKg4apE',
        'Content-Type': 'application/json',
      };
      _addDioInterceptor();
      return _dio!;
    } else {
      return _dio!;
    }
  }

  void _addDioInterceptor() {
    _dio?.interceptors.add(
      PrettyDioLogger(
        // requestBody: true,
        // requestHeader: true,
        responseBody: false,
        // responseHeader: true,
      ),
    );
  }

  Future<String> geminiRephrase(String str) async {
    Dio dio = await _getDio();
    var data = json.encode({
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Rephrase the following sentence in a better way without adding any content. Keep the response in the same language as the input sentence. Provide only the rephrased sentence without any additional text:"
            },
            {"text": str}
          ]
        }
      ]
    });

    var response = await dio.request(
      '/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyCauyBI0vPC_4qKsM7hF26jHFnOyKg4apE',
      options: Options(
        method: 'POST',
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      String rephrasedSentence = '';

      response.data['candidates'][0]['content']['parts'].forEach((element) {
        return rephrasedSentence += element['text'];
      });

      debugPrint(rephrasedSentence);
      return rephrasedSentence;
    } else {
      debugPrint(response.statusMessage);
      return response.statusMessage.toString();
    }
  }
}
