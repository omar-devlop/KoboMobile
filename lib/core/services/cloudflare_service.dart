import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/api/api_keys.dart';

class CloudflareService {
  final Dio _dio;

  CloudflareService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.cloudflare.com/client/v4',
          headers: {
            'Authorization': 'Bearer $cloudflareApiToken',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
  // ..interceptors.add(
  //   PrettyDioLogger(
  //     // requestBody: true,
  //     // requestHeader: true,
  //     responseBody: true,
  //     // responseHeader: true,
  //   ),
  // );

  Future<String?> generateAIResponse(String prompt) async {
    final String endpoint =
        '/accounts/$cloudflareAccountId/ai/run/@cf/meta/llama-3.1-8b-instruct';

    try {
      final response = await _dio.post(
        endpoint,
        data: {
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an expert in KoBoToolbox, languages, and data. Rephrase the given form title in five different ways, preserving the original language and meaning. Respond only with five titles as a plain list, each preceded by a dash and a space (“- ”). Do not include any additional text, explanations, or numbering.",
            },

            {"role": "user", "content": prompt},
          ],
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['result']['response'];
      } else {
        debugPrint('Cloudflare AI error: ${response.data}');
      }
    } catch (e) {
      debugPrint('Dio error: $e');
    }

    return null;
  }
}
