import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Common/widgets/show_snackbar.dart';
import '../../utils/constants/api_constants.dart';
import '../models/questions_response.dart';
import '../models/summary_response.dart';

class ApiServices {
  // Base URL

  // Dio instance
  final Dio _dio = Dio();

  Future<String?> _getFormattedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return token;
  }

  /// Sign Up User
  Future<bool> signUpUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    const String endpoint = '/api/auth/signup';
    const String url = '$baseUrl$endpoint';

    final Map<String, dynamic> requestBody = {
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "password": password,
      "email": email,
      "phoneNumber": phoneNumber,
    };

    try {
      Response response = await _dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // final token = response.data['token'];
        print('User registered successfully: ${response.data}');
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('auth_token', token);
        showSnackBar(context, 'User registered successfully, Try to login now',
            Colors.green);
        return true;
      } else {
        print(
            'Failed to register user: ${response.statusCode} - ${response.data}');
        showSnackBar(context, "Failed to register user", Colors.red);
        return false;
      }
    } on DioException catch (error) {
      if (error.response != null) {
        print('DioError Response: ${error.response?.data}');
      } else {
        print('DioError: ${error.message}');
      }
      return false;
    } catch (error) {
      print('Unexpected error: $error');
    }
    return false;
  }

  /// Login User
  Future<bool> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    const String endpoint = '/api/auth/login';
    const String url = '$baseUrl$endpoint';

    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    try {
      Response response = await _dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        print('Login successful! Token: $token');
        showSnackBar(context, "Login successful!", Colors.green);

        //! save the token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', token);
        return true;
      } else {
        print('Login failed: ${response.statusCode} - ${response.data}');
        showSnackBar(context, "Login failed", Colors.red);
        return false;
      }
    } on DioException catch (error) {
      if (error.response != null) {
        print('DioError Response: ${error.response?.data}');
      } else {
        print('DioError: ${error.message}');
      }
      return false;
    } catch (error) {
      print('Unexpected error: $error');
    }
    return false;
  }

  Future<SummaryResponse?> createSummary({
    required BuildContext context,
    required String filePath,
  }) async {
    const String endpoint = '/api/summarize';
    final String url = '$baseUrl$endpoint';

    try {
      String? token = await _getFormattedToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      String fileName = filePath.split('/').last;
      String mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      Response response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        print('API Response: ${response.data}');
        return SummaryResponse.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to create summary: ${response.statusMessage}');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
      return null;
    }
  }

  Future<List<String>?> generateQuestions({
    required BuildContext context,
    required String summaryId,
    required int number,
  }) async {
    const String endpoint = '/api/questions';
    final String url = '$baseUrl$endpoint';

    try {
      String? token = await _getFormattedToken();
      if (token == null) throw Exception('Authentication token not found');

      Response response = await _dio.post(
        url,
        data: {
          'summaryId': summaryId,
          'number': number,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final questionsResponse = QuestionsResponse.fromJson(response.data);
        return questionsResponse.questions;
      }
      throw Exception(
          'Failed to generate questions: ${response.statusMessage}');
    } catch (e) {
      print('Error in generateQuestions: $e');
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
      return null;
    }
  }

  Future<String?> getSummaryById({
    required BuildContext context,
    required String summaryId,
  }) async {
    const String endpoint = '/api/summarize';
    final String url = '$baseUrl$endpoint';

    try {
      String? token = await _getFormattedToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      Response response = await _dio.get(
        '$url/$summaryId',
        options: Options(
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Debug print to see the response structure
        print('API Response: ${response.data}');

        if (response.data is Map<String, dynamic>) {
          // Assuming the summary is nested in a 'summary' field
          final summaryData = response.data as Map<String, dynamic>;
          // Try different possible field names
          final summaryText = summaryData['summary']['summary'] ??
              summaryData['text'] ??
              summaryData['content'] ??
              'No summary content found';
          return summaryText.toString();
        } else {
          // If response.data is directly the summary string
          return response.data.toString();
        }
      } else {
        throw Exception('Failed to fetch summary: ${response.statusMessage}');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
      return null;
    }
  }
}
