import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/expendituremethodesconstants.dart';
//import 'package:workspace/constants/Expendituremethodesconstants.dart';
import 'package:workspace/Models/expenditurelist.dart';
import 'package:workspace/Models/activitylist.dart';
import 'package:workspace/Models/suggestion.dart';
import 'package:workspace/Models/sumlist.dart';

import '../constants/app_constants.dart';
import '../Models/response_model.dart';

class ExpenditureService {
  static final ExpenditureService _apiService = ExpenditureService._init();

  factory ExpenditureService() {
    return _apiService;
  }

  ExpenditureService._init();

  //add new Expenditure
  Future<Response> addNewExpenditure(
      ActivityList a, String duration, double weight, String userid) async {
    final request = await http.post(
        Uri.http(
            Url,
            ExpenditureMethodConstants.ADD_NEW_expenditure +
                "/" +
                a.id +
                "/" +
                a.name +
                "/" +
                duration +
                "/" +
                a.met.toString() +
                "/" +
                weight.toString() +
                "/" +
                userid),
        body: jsonEncode(a.toJson()),
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

  Future<Response> addNewExpenditureb(String id, String name, double met,
      String duration, double weight, String userid) async {
    final request = await http.post(
        Uri.http(
            Url,
            ExpenditureMethodConstants.ADD_NEW_expenditure +
                "/" +
                id +
                "/" +
                name +
                "/" +
                duration +
                "/" +
                met.toString() +
                "/" +
                weight.toString() +
                "/" +
                userid),
        //body: jsonEncode(a.toJson()),
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
  Future<List<ExpenditureList>> getAllExpenditures(String userid) async {
    final request = await http.get(
        Uri.http(Url,
            ExpenditureMethodConstants.LIST_ALL_expenditures + "/" + userid),
        headers: AppConstants.HEADERS);
    List<ExpenditureList> list = [];
    try {
      if (request.statusCode == 200) {
        list = ExpenditureListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<ExpenditureList>();
    }
    return list;
  }

  Future<List<ExpenditureList>> getExpenditures(String userid) async {
    final request = await http.get(
        Uri.http(Url,
            ExpenditureMethodConstants.LIST_ALL_expenditures + "/" + userid),
        headers: AppConstants.HEADERS);
    List<ExpenditureList> list = [];
    try {
      if (request.statusCode == 200) {
        list = ExpenditureListFromJson(request.body);
        print("abc");
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<ExpenditureList>();
    }
    return list;
  }

  Future<List<ExpenditureList>> todayExpenditures(String userid) async {
    final request = await http.get(
        Uri.http(Url, ExpenditureMethodConstants.Today + "/" + userid),
        headers: AppConstants.HEADERS);
    List<ExpenditureList> list = [];
    try {
      if (request.statusCode == 200) {
        list = ExpenditureListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<ExpenditureList>();
    }
    return list;
  }

  Future<List<ExpenditureList>> dayExpenditures(
      DateTime date, String userid) async {
    final request = await http.get(
        Uri.http(
            Url,
            ExpenditureMethodConstants.Day +
                "/" +
                date.toString() +
                "/" +
                userid),
        headers: AppConstants.HEADERS);
    List<ExpenditureList> list = [];
    try {
      if (request.statusCode == 200) {
        list = ExpenditureListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<ExpenditureList>();
    }
    return list;
  }

  Future<Response> deleteExpenditure(String id) async {
    final request = await http.get(
        Uri.http(Url, ExpenditureMethodConstants.DELETE_expenditure + "/" + id),
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

  Future<int> ActiveDays(String userid) async {
    final request = await http.get(
        Uri.http(Url, ExpenditureMethodConstants.ActiveDays + "/" + userid),
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

  Future<double> CaloriesBurned(String userid) async {
    final request = await http.get(
        Uri.http(Url,
            ExpenditureMethodConstants.CaloriesLastexpenditures + "/" + userid),
        headers: AppConstants.HEADERS);
    double x = 0.0;
    try {
      if (request.statusCode == 200) {
        x = double.parse(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return x;
    }
    return x;
  }

  Future<List<Suggestion>> stats(String userid) async {
    List<Suggestion> statlist = [];
    final request = await http.get(
        Uri.http(Url,
            ExpenditureMethodConstants.CaloriesLastexpenditures + "/" + userid),
        headers: AppConstants.HEADERS);
    double x = 0.0;

    int y = 0;
    final request2 = await http.get(
        Uri.http(Url, ExpenditureMethodConstants.ActiveDays + "/" + userid),
        headers: AppConstants.HEADERS);

    try {
      if (request.statusCode == 200) {
        x = double.tryParse(request.body);
        Suggestion s2 = new Suggestion(
            "Calories brulé ", x.toString() + " Kcal", "calories");
        statlist.add(s2);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return statlist;
    }

    try {
      if (request.statusCode == 200) {
        y = int.tryParse(request2.body);
        Suggestion s = new Suggestion(
            "Jours Actif", y.toString() + " / 14 jours", "activity");
        statlist.add(s);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return statlist;
    }

    return statlist;
  }

  Future<List<SumList>> sumOne(String userid) async {
    final request = await http.get(
        Uri.http(Url,
            ExpenditureMethodConstants.CaloriesLastexpenditures + "/" + userid),
        headers: AppConstants.HEADERS);
    List<SumList> list = [];
    try {
      if (request.statusCode == 200) {
        list = SumListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<SumList>();
    }
    return list;
  }
}
