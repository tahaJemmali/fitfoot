import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/routinemethodesconstants.dart';
import 'package:workspace/Models/routine.dart';
import 'package:workspace/Models/routinelist.dart';

import '../constants/app_constants.dart';
import '../Models/response_model.dart';

class RoutineService {
  static final RoutineService _apiService = RoutineService._init();

  factory RoutineService() {
    return _apiService;
  }

  RoutineService._init();

  //add new Routine
  Future<Response> addNewRoutine(Routine routine) async {
    final request = await http.post(
        Uri.http(
            Url,
            RoutineMethodConstants.ADD_NEW_routine +
                "/" +
                routine.medid +
                "/" +
                routine.medname +
                "/" +
                routine.userid),
        body: jsonEncode(routine.toJson()),
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
  Future<List<RoutineList>> getAllRoutines() async {
    print("id:" + Home.currentUser.id);
    final request = await http.get(
        Uri.http(Url,
            RoutineMethodConstants.LIST_routine + "/" + Home.currentUser.id),
        headers: AppConstants.HEADERS);
    List<RoutineList> list = [];
    try {
      if (request.statusCode == 200) {
        list = RoutineListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<RoutineList>();
    }
    return list;
  }

  //delete
  Future<Response> deleteRoutine(String id) async {
    //String json = '{"id" : "$id"}';
    final request = await http.get(
        Uri.http(Url, RoutineMethodConstants.DELETE_routine + "/" + id),
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
}
