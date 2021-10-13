import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/intakemethodesconstants.dart';
import 'package:workspace/Models/Intake.dart';
import 'package:workspace/Models/Intakelist.dart';

import '../constants/app_constants.dart';
import '../Models/response_model.dart';

class IntakeService {
  static final IntakeService _apiService = IntakeService._init();

  factory IntakeService() {
    return _apiService;
  }

  IntakeService._init();

  //add new Intake
  Future<Response> addNewIntake(Intake intake) async {
    final request = await http.post(
        Uri.http(
            Url,
            IntakeMethodConstants.ADD_NEW_intake +
                "/" +
                intake.medid +
                "/" +
                intake.medname +
                "/" +
                intake.userid),
        body: jsonEncode(intake.toJson()),
        headers: AppConstants.HEADERS);
    Response response = Response();
    try {
      if (request.statusCode == 201) {
        response = responseFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return Response();
    }
    return response;
  }

  //get all data
  Future<List<IntakeList>> getAllIntakes(String userid) async {
    final request = await http.get(
        Uri.http(Url, IntakeMethodConstants.LIST_ALL_intakes + "/" + userid),
        headers: AppConstants.HEADERS);
    List<IntakeList> list = [];
    try {
      if (request.statusCode == 200) {
        list = IntakeListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<IntakeList>();
    }
    return list;
  }

  Future<List<IntakeList>> getIntakes(String userid) async {
    final request = await http.get(
        Uri.http(Url, IntakeMethodConstants.LIST_ALL_intakes + "/" + userid),
        headers: AppConstants.HEADERS);
    List<IntakeList> list = [];
    try {
      if (request.statusCode == 200) {
        list = IntakeListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<IntakeList>();
    }
    return list;
  }

  Future<Response> checkIntake(String id) async {
    final request = await http.put(
        Uri.http(Url, IntakeMethodConstants.UPDATE_intake + "/" + id),
        //body: json,
        headers: AppConstants.HEADERS);
    Response response = Response();
    try {
      if (request.statusCode == 201) {
        response = responseFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return Response();
    }
    return response;
  }

  Future<List<IntakeList>> todayIntakes(String userid) async {
    final request = await http.get(
        Uri.http(Url, IntakeMethodConstants.Today + "/" + userid),
        headers: AppConstants.HEADERS);
    List<IntakeList> list = [];
    try {
      if (request.statusCode == 200) {
        list = IntakeListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<IntakeList>();
    }
    return list;
  }

  Future<List<IntakeList>> dayIntakes(DateTime date, String userid) async {
    final request = await http.get(
        Uri.http(Url,
            IntakeMethodConstants.Day + "/" + date.toString() + "/" + userid),
        headers: AppConstants.HEADERS);
    List<IntakeList> list = [];
    try {
      if (request.statusCode == 200) {
        list = IntakeListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<IntakeList>();
    }
    return list;
  }

  Future<List<IntakeList>> LastIntakes(String userid) async {
    final request = await http.get(
        Uri.http(Url, IntakeMethodConstants.LastIntakes + "/" + userid),
        headers: AppConstants.HEADERS);
    List<IntakeList> list = [];
    try {
      if (request.statusCode == 200) {
        list = IntakeListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<IntakeList>();
    }
    return list;
  }

  Future<int> CountIntakes(String userid) async {
    final request = await http.get(
        Uri.http(Url, IntakeMethodConstants.CountLastIntakes + "/" + userid),
        headers: AppConstants.HEADERS);
    int x = 0;
    try {
      if (request.statusCode == 200) {
        x = int.tryParse(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return x;
    }
    return x;
  }

  Future<int> CountCheckedIntakes(String userid) async {
    final request = await http.get(
        Uri.http(
            Url, IntakeMethodConstants.CountLastCheckedIntakes + "/" + userid),
        headers: AppConstants.HEADERS);
    int x = 0;
    try {
      if (request.statusCode == 200) {
        x = int.tryParse(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return x;
    }
    return x;
  }
}
