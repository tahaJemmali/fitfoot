import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/medmethodsconstants.dart';
import 'package:workspace/Models/Med.dart';
import 'package:workspace/Models/medlist.dart';

import '../constants/app_constants.dart';
import '../Models/response_model.dart';

class MedService {
  static final MedService _apiService = MedService._init();

  factory MedService() {
    return _apiService;
  }

  MedService._init();

  //add new Med
  Future<Response> addNewMed(Med med) async {
    final request = await http.post(
        Uri.http(
            Url,
            MedMethodConstants.ADD_NEW_med +
                "/" +
                med.name +
                "/" +
                med.type +
                "/" +
                med.nb.toString()),
        body: jsonEncode(med.toJson()),
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
  Future<List<MedList>> getAllMeds() async {
    final request = await http.get(
        Uri.http(Url, MedMethodConstants.LIST_ALL_meds),
        headers: AppConstants.HEADERS);
    List<MedList> list = [];
    try {
      if (request.statusCode == 200) {
        list = MedListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<MedList>();
    }
    return list;
  }

  Future<List<MedList>> getCustomMeds(String id) async {
    final request = await http.get(
        Uri.http(Url, MedMethodConstants.get_custom_med + "/" + id),
        headers: AppConstants.HEADERS);
    List<MedList> list = [];
    try {
      if (request.statusCode == 200) {
        list = MedListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<MedList>();
    }
    return list;
  }

  Future<MedList> getMed(String id) async {
    final request = await http.get(
        Uri.http(Url, MedMethodConstants.One_med + "/" + id),
        headers: AppConstants.HEADERS);
    MedList med;
    List<MedList> list = [];
    try {
      if (request.statusCode == 200) {
        list = MedListFromJson(request.body);
        var jsonResponse = convert.jsonDecode(request.body);
        if (jsonResponse['routine'] != null) {
          MedList med = MedList.medFromJson(jsonResponse['med']);
        }
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return med;
    }
    return med;
  }

  Future<List<MedList>> toMed(String id) async {
    final request = await http.get(
        Uri.http(Url, MedMethodConstants.One_med + "/" + id),
        headers: AppConstants.HEADERS);
    List<MedList> list = [];
    try {
      if (request.statusCode == 200) {
        list = MedListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<MedList>();
    }
    return list;
  }

  Future<Response> customMed(Med med, String creatorid) async {
    final request = await http.post(
        Uri.http(
            Url,
            MedMethodConstants.custom_med +
                "/" +
                med.name +
                "/" +
                med.type +
                "/" +
                creatorid),
        body: jsonEncode(med.toJson()),
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

  Future<Response> deleteMed(String id) async {
    //String json = '{"id" : "$id"}';
    final request =
        await http.get(Uri.http(Url, MedMethodConstants.DELETE_med + "/" + id),
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
