import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:expensefrontend/data/api/secure_storage.dart';
import 'package:expensefrontend/data/models/activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

import '../models/balance.dart';
import '../models/expense.dart';
import '../models/groups_model.dart';
import '../models/member.dart';

class ApiClient1 {


  // 10.0.2.2
  Dio dio = Dio(BaseOptions(
    baseUrl: Platform.isAndroid ? "http://10.0.2.2:8080" : "http://localhost:8080",
    connectTimeout: Duration(milliseconds: 30000),
    receiveTimeout: Duration(milliseconds: 30000),
  ));
  final _secureStorage = SecureStorage();

  ApiClient1() {
    dio.interceptors.add(
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
    );
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

      return response.data;
    } on DioException catch (e) {
      throw ErrorDescription('Failed to Login: ${e.response?.data['error']}');
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
        throw ErrorDescription("Failed to Register : Internal server Error");
      } else if (e.response?.statusCode == 409) {
        throw ErrorDescription("Failed to Register : Email ID already exists");
      } else {
        throw ErrorDescription('Failed to Register: ${e.message}');
      }
    }
  }

  Future<void> logout() async {
    try {
      final token = await _secureStorage.readSecureData('token');
      // final response = await dio.post(
      //   'http://10.0.2.2:8080/auth/logout',
      //   data: {'token': token},
      //   options: Options(
      //       contentType: 'application/json',
      //       headers: {'Authorization': 'Bearer $token'}),
      // );
      // if (response.statusCode == 200) {
      await _secureStorage.deleteSecureData('token');
      await _secureStorage.deleteSecureData('userId');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("name");
      await prefs.remove("emailId");
      // }
    } on DioException catch (e) {
      throw Exception('Failed to logout: ${e.message}');
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
      throw Exception('Failed to create group: ${e.message}');
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
      throw Exception('Failed to fetch groups: ${e.message}');
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
        throw Exception("Member already a part of group");
      } else {
        throw ErrorDescription("Member not found");
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
        throw ErrorDescription("You can not add members.");
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
      throw Exception(e.message);
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
        throw ErrorDescription(e.response?.data['message']);
      } else {
        throw Exception(e.message);
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
      throw Exception(e.error);
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
      throw Exception(e.error);
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
      throw Exception(e.error);
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
      throw Exception(e.error);
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
      throw Exception(e.error);
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
      throw Exception(e.error);
    }
  }

  // Future<String> getCSV(int groupId) async {
  //   try {
  //     final token = await _secureStorage.readSecureData('token');
  //
  //     Directory directory = await getTemporaryDirectory();
  //     // var directory = await getApplicationDocumentsDirectory();
  //     String filePath = '${directory.path}/report.csv';
  //     final response = await dio.download(
  //       '/get-csv',
  //       filePath,
  //       queryParameters: {'groupId': groupId},
  //       options: Options(
  //           contentType: 'text/csv; charset=UTF-8',
  //           headers: {'Authorization': 'Bearer $token'}),
  //     );
  //     print(filePath);
  //
  //     File tempFile = File(filePath);
  //     Uint8List fileBytes = await tempFile.readAsBytes();
  //
  //     // String downloadPath = await saveCsv(fileBytes);
  //     // debugPrint(downloadPath);
  //     //
  //     // final taskId = await FlutterDownloader.enqueue(
  //     //   url: downloadPath,
  //     //   headers: {}, // optional: header send with url (auth token etc)
  //     //   savedDir:"/storage/emulated/0/Android/data/com.example.expensefrontend/files",
  //     //   showNotification: true, // show download progress in status bar (for Android)
  //     //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  //     // );
  //     // FlutterDownloader.open(taskId: taskId!);
  //
  //
  //
  //     return filePath;
  //   } on DioException catch (e) {
  //     throw Exception(e.error);
  //   }
  // }

  // Future<String> saveCsv(
  //     // Uint8List csvData,
  //     int groupId
  //     ) async {
  //   Directory? downloadsDirectory = await getExternalStorageDirectory();
  //
  //   // Create the Download folder path
  //   String downloadPath = '${downloadsDirectory!.path}/Download';
  //
  //   // Check if the Download directory exists, and create it if it doesn't
  //   Directory downloadDir = Directory(downloadPath);
  //   if (!await downloadDir.exists()) {
  //     await downloadDir.create(
  //         recursive:
  //             true); // Creates the directory and any necessary parent directories
  //   }
  //
  //   // Define the file path for saving the report.csv
  //   String filePath = '$downloadPath/report.csv';
  //
  //   // Save the file
  //   // File file = File(filePath);
  //
  //   // strat here
  //
  //   final token = await _secureStorage.readSecureData('token');
  //   final response = await dio.download(
  //     '/get-csv',
  //     filePath,
  //     queryParameters: {'groupId': groupId},
  //     options: Options(
  //         contentType: 'text/csv; charset=UTF-8',
  //         headers: {'Authorization': 'Bearer $token'}),
  //   );
  //
  //   final result = await OpenFile.open(filePath);
  //
  //   if (result.type != ResultType.done) {
  //     print("Error opening file: ${result.message}");
  //   }
  //
  //   return filePath;
  //
  //   // final taskId = await FlutterDownloader.enqueue(
  //   //   url: 'file:///$filePath',
  //   //   headers: {}, // optional: header send with url (auth token etc)
  //   //   savedDir:downloadPath,
  //   //   fileName: 'report.csv',
  //   //   showNotification: true, // show download progress in status bar (for Android)
  //   //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  //   // );
  //   // await _waitForDownloadCompletion(taskId!);
  //   //
  //   // // Open the file
  //   // await FlutterDownloader.open(taskId: taskId);
  //
  //   // return filePath;
  //   // end here
  //
  //   // await file.writeAsBytes(csvData);
  //
  //   return filePath;
  //
  // }




  Future<void> newDownload(int groupId,String groupName)async{

    try {
      final token = await _secureStorage.readSecureData('token');
      late Directory downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      final taskId = await FlutterDownloader.enqueue(
        url: 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080/get-csv/$groupId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': "text/csv",
          // 'Accept': '*/*',
          'Content-disposition': "attachment;filename=report.csv",
        },
        // optional: header send with url (auth token etc)
        savedDir: downloadsDirectory.path,
        fileName: '${groupName}Report.csv',
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
      await _waitForDownloadCompletion(taskId!);

      // Open the file
      await FlutterDownloader.open(taskId: taskId);
    }catch(e){
      debugPrint(e.toString());
      throw Exception("Can not download file.");
    }

  }

  Future<void> _waitForDownloadCompletion(String taskId) async {
    bool isComplete = false;
    while (!isComplete) {
      await Future.delayed(Duration(milliseconds: 500));
      final tasks = await FlutterDownloader.loadTasks();
      final task = tasks?.firstWhere((task) => task.taskId == taskId);
      if (task?.status == DownloadTaskStatus.complete) {
        isComplete = true;
      }
    }
  }

//   Future<String> download(int groupId) async {
//     final token = await _secureStorage.readSecureData('token');
//     // Directory directory = await getTemporaryDirectory();
//     // String filePath = 'file:${directory.path}/report.csv';
//     // print(filePath);
//
//     // final response = await dio.get(
//     //   '/get-csv',
//     //   queryParameters: {'groupId': groupId},
//     //   options: Options(
//     //       // contentType: 'application/json',
//     //       headers: {
//     //         'Authorization': 'Bearer $token',
//     //         'Content-Type': 'text/csv',
//     //         'Content-Disposition': 'attachment;filename=report.csv',
//     //       },
//     //       responseType: ResponseType.stream),
//     // );
//
//     // final url = Uri.dataFromBytes(response.data, mimeType: 'text/csv')
//     //     .replace(queryParameters: {'filename': 'report.csv'});
//     //
//     // await launchUrl(url);
//     // print(response.data);
//     // final tempDir = await getTemporaryDirectory();
//     // final filePath = '${tempDir.path}/report.csv';
//     // print(filePath);
//     // final file = File(filePath);
//     // final sink = file.openWrite();
//     //
//     // await response.data.stream.forEach((data) {
//     //   sink.add(data);
//     // });
//     // await sink.flush();
//     // await sink.close();
//     //
//     // final url = Uri.file(filePath);
//     // if (await canLaunchUrl(url)) {
//     //   await launchUrl(url);
//     // }
//
//     // final file = File(filePath);
//     // await file.writeAsBytes(response.data);
//     //
//     // final Uri uri = Uri.file(filePath);
//     // await launchUrl(uri);
// //     if (!File(uri.toFilePath()).existsSync()) {
// //       throw Exception('$uri does not exist!');
// //     }
// // print(filePath);
//     // await launchUrl(Uri.file(filePath));
//     // if (!await launchUrl(Uri.file('r'+filePath,windows: true))) {
//     //   throw Exception('Could not launch $filePath');
//     // }
//     // Directory? directory = await getExternalStorageDirectory();
//     // final filePath = '${directory!.path}/report.csv';
//     //
//     //
//     // final file = File(filePath);
//     // await file.writeAsBytes(response.data);
//     //
//     // final taskId = await FlutterDownloader.enqueue(
//     //   url: filePath,
//     //   headers: {}, // optional: header send with url (auth token etc)
//     //   savedDir: directory.path,
//     //   fileName: 'report.csv',
//     //   showNotification:
//     //       true, // show download progress in status bar (for Android)
//     //   openFileFromNotification:
//     //       true, // click on notification to open downloaded file (for Android)
//     // );
//
//     final response = await dio.get(
//       '/get-csv',
//       queryParameters: {'groupId': groupId},
//       options: Options(
//         responseType: ResponseType.bytes,
//         headers: {
//           'Content-Type': 'text/csv; charset=UTF-8',
//           'Content-Disposition': 'attachment;filename=report.csv',
//           'Authorization': 'Bearer $token',
//         },
//       ),
//     );
//
//     final bytes = response.data;
//     final blob = Uint8List.fromList(bytes);
//     final uri = Uri.dataFromBytes(blob, mimeType: 'text/csv')
//         .replace(queryParameters: {'filename': 'report.csv'});
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw Exception('Could not launch $uri');
//     }
//     return "sdf";
//   }
}
