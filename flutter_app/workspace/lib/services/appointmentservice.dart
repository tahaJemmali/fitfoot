import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/appointmentmethodesconstants.dart';
import 'package:workspace/Models/appointment.dart';
import 'package:workspace/Models/appointmentlist.dart';

import '../constants/app_constants.dart';
import '../Models/response_model.dart';

class AppointmentService {
  static final AppointmentService _apiService = AppointmentService._init();

  factory AppointmentService() {
    return _apiService;
  }

  AppointmentService._init();

  //add new Appointment
  Future<Response> addNewAppointment(
      Appointment appointment, String date, String userid) async {
    final request = await http.post(
        Uri.http(
            Url,
            AppointmentMethodConstants.ADD_NEW_appointment +
                "/" +
                appointment.doctorname +
                "/" +
                appointment.doctorphone +
                "/" +
                date +
                "/" +
                appointment.specialty +
                "/" +
                userid),
        body: jsonEncode(appointment.toJson()),
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
  Future<List<AppointmentList>> getAllAppointments(String userid) async {
    final request = await http.get(
        Uri.http(Url,
            AppointmentMethodConstants.LIST_ALL_appointments + "/" + userid),
        headers: AppConstants.HEADERS);
    List<AppointmentList> list = [];
    try {
      if (request.statusCode == 200) {
        list = AppointmentListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<AppointmentList>();
    }
    return list;
  }

  Future<List<AppointmentList>> getAppointments(String userid) async {
    final request = await http.get(
        Uri.http(Url,
            AppointmentMethodConstants.LIST_ALL_appointments + "/" + userid),
        headers: AppConstants.HEADERS);
    List<AppointmentList> list = [];
    try {
      if (request.statusCode == 200) {
        list = AppointmentListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<AppointmentList>();
    }
    return list;
  }

  Future<Response> checkAppointment(String id) async {
    final request = await http.put(
        Uri.http(Url, AppointmentMethodConstants.UPDATE_appointment + "/" + id),
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

  Future<List<AppointmentList>> todayAppointments(String userid) async {
    final request = await http.get(
        Uri.http(Url, AppointmentMethodConstants.Today + "/" + userid),
        headers: AppConstants.HEADERS);
    List<AppointmentList> list = [];
    try {
      if (request.statusCode == 200) {
        list = AppointmentListFromJson(request.body);
        print(list.length);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<AppointmentList>();
    }
    return list;
  }

  Future<Response> deleteAppointment(String id) async {
    final request = await http.get(
        Uri.http(Url, AppointmentMethodConstants.DELETE_appointment + "/" + id),
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
