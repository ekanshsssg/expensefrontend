import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expensefrontend/data/api/secure_storage.dart';
import 'package:expensefrontend/data/models/activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../pages/home.dart';
import '../models/balance.dart';
import '../models/expense.dart';
import '../models/groups_model.dart';
import '../models/member.dart';


class Repository {

  Dio dio = Dio(BaseOptions(
    baseUrl: "http://13.232.14.58:8080",
    connectTimeout: Duration(milliseconds: 30000),
    receiveTimeout: Duration(milliseconds: 30000),
  ));
  final _secureStorage = SecureStorage();

  Repository() {
    dio.interceptors.addAll([
      InterceptorsWrapper(onError: (error, handler) async {

        if (error.response?.statusCode == 401) {
          await logout();
        }
        return handler.next(error);
      }),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          print(object);
        },
      ),
    ]);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'emailid': email, 'password': password},
        options: Options(contentType: 'application/json'),
      );
      await _secureStorage.writeSecureData("token", response.data['token']);
      await _secureStorage.writeSecureData(
          "userId", response.data['userId'].toString());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", response.data['name']);
      await prefs.setString("emailId", email);
      await prefs.setBool("isUserLoggedIn", true);

      return response.data;
    } on DioException catch (e) {
      throw 'Failed to Login: ${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {'name': name, 'emailid': email, 'password': password},
        options: Options(contentType: 'application/json'),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw "Failed to Register : Internal server Error";
      } else if (e.response?.statusCode == 409) {
        throw "Failed to Register : Email ID already exists";
      } else {
        throw 'Failed to Register: ${e.message}';
      }
    }
  }

  Future<void> logout() async {
    try {
      await _secureStorage.deleteSecureData('token');
      await _secureStorage.deleteSecureData('userId');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.remove("name");
      // await prefs.remove("emailId");
      // await prefs.remove("isUserLoggedIn");
      prefs.clear();
    } on DioException catch (e) {
      throw 'Failed to logout: ${e.message}';
    }
  }

  Future<Map<String, dynamic>> createGroup(Group group) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final response = await dio.post(
        '/group/create-group',
        data: {
          'name': group.name,
          'description': group.description,
          'created_by': group.created_by,
          'group_members': group.group_members,
        },
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw 'Failed to create group: ${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<List<Map<String, dynamic>>> fetchGroups() async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final userId = await _secureStorage.readSecureData('userId');
      final response = await dio.get(
        '/group/$userId',
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      // print(response);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw 'Failed to fetch groups: ${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<Member> searchMembersByEmail(String email, int groupId) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final response = await dio.get(
        '/group/search-members',
        queryParameters: {'emailId': email, 'groupId': groupId},
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );

      return Member.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw "Member already a part of group";
      } else {
        throw "Member not found";
      }
    }
  }

  Future<void> addMembersToGroup(
      int groupId, List<Member> members, int userId) async {
    try {
      final token = await _secureStorage.readSecureData('token');

      final response = await dio.post(
        '/group/add-members',
        data: {
          'group_id': groupId,
          'user_id': userId,
          'members': members.map((e) => e.memberId).toList(),
        },
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw "You can not add members.";
      }
      throw Exception(e);
    }
  }

  Future<List<Member>> fetchGroupMembers(int groupId) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final response = await dio.get(
        '/group/get-members',
        queryParameters: {'groupId': groupId},
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      List<dynamic> data = response.data;
      List<Member> members =
          data.map((member) => Member.fromJson(member)).toList();

      return members;
    } on DioException catch (e) {
      throw "${e.response?.data['error'] ?? e.message}";
    }
  }

  Future<String> deleteSelectedMembers(
      int groupId, List<int> selectedMembers, int userId) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final response = await dio.post(
        '/group/delete-members',
        data: {
          'group_id': groupId,
          'members': selectedMembers,
          'user_id': userId
        },
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['success'];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw e.response?.data['message'];
      } else {
        throw "${e.message}";
      }
    }
  }

  Future<void> addExpense(String category, int groupId, int paidBy,
      List<int> members, String description, double amount) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final response = await dio.post(
        '/add-expense',
        data: {
          'group_id': groupId,
          'category': category,
          'amount': amount,
          'description': description,
          'paid_by': paidBy,
          'expense_members': members,
        },
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw '${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<List<Expense>> getExpense(int groupId) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final userId = await _secureStorage.readSecureData('userId');
      final response = await dio.get(
        '/get-expense',
        queryParameters: {'groupId': groupId, 'userId': userId},
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 204) {
        return [];
      }
      Expenses result = Expenses.fromJson(response.data);
      print(result.expenses);
      return result.expenses;
    } on DioException catch (e) {
      throw '${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<List<Balance>> getBalances(int groupId) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final userId = await _secureStorage.readSecureData('userId');
      final response = await dio.get(
        '/get-balance',
        queryParameters: {'groupId': groupId, 'userId': userId},
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 204) {
        return [];
      }
      Balances result = Balances.fromJson(response.data);
      print(result.balances);
      return result.balances;
    } on DioException catch (e) {
      throw '${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<double> getOverallBalance() async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final userId = await _secureStorage.readSecureData('userId');
      final response = await dio.get(
        '/get-overall-balance',
        queryParameters: {'userId': userId},
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      print(response.data['balance'].runtimeType);
      final double balance = response.data['balance'].runtimeType == int
          ? response.data['balance'].toDouble()
          : response.data['balance'];
      return balance;
    } on DioException catch (e) {
      throw '${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<String> addSettlement(
      int groupId, double amount, int settleWith, String str) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final userId = int.parse(await _secureStorage.readSecureData('userId'));
      print(userId);
      final response = await dio.post(
        '/add-settlement',
        data: {
          'group_id': groupId,
          'amount': amount,
          'user_received': str == "received" ? settleWith : userId,
          'user_paid': str == "paid" ? settleWith : userId,
        },
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['success'];
    } on DioException catch (e) {
      throw '${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<List<Activity>> getActivity() async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final userId = int.parse(await _secureStorage.readSecureData('userId'));
      // print(userId);
      final response = await dio.get(
        '/activity',
        queryParameters: {'userId': userId},
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 204) {
        return [];
      }
      Activities result = Activities.fromJson(response.data);
      return result.activities;
    } on DioException catch (e) {
      throw '${e.response?.data['error'] ?? e.message}';
    }
  }

  Future<void> newDownload(int groupId, String groupName) async {
    try {
      final token = await _secureStorage.readSecureData('token');
      final response = await dio.get(
        '/get-csv',
        queryParameters: {'groupid': groupId, 'groupName': groupName},
        options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'Bearer $token'}),
      );
      final url = jsonDecode(response.data)['url'];
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode
              .externalApplication, // Launch in an external application
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ("File cannot be downloaded");
    }
  }
}
