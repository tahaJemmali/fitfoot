import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/activitymethodesconstants.dart';
import 'package:workspace/Models/activity.dart';
import 'package:workspace/Models/activitylist.dart';

import '../constants/app_constants.dart';
import '../Models/response_model.dart';

class ActivityService {
  static final ActivityService _apiService = ActivityService._init();

  factory ActivityService() {
    return _apiService;
  }

  ActivityService._init();

  //add new Activity
  Future<Response> addNewActivity(Activity activity) async {
    final request = await http.post(
        Uri.http(
            Url,
            ActivityMethodConstants.ADD_NEW_activity +
                "/" +
                activity.name +
                "/" +
                activity.met.toString()),
        body: jsonEncode(activity.toJson()),
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
  Future<List<ActivityList>> getAllActivities() async {
    final request = await http.get(
        Uri.http(Url, ActivityMethodConstants.LIST_ALL_activities),
        headers: AppConstants.HEADERS);
    List<ActivityList> list = [];
    try {
      if (request.statusCode == 200) {
        list = ActivityListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<ActivityList>();
    }
    return list;
  }
}
