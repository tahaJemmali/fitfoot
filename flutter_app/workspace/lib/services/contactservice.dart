import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Models/contact.dart';
import 'package:workspace/Models/contactlist.dart';

import '../constants/app_constants.dart';
import '../constants/contactmethodsconstants.dart';
import '../Models/response_model.dart';
//import '../Models/Contactlist.dart';
import '../Models/contact.dart';

class ContactService {
  static final ContactService _apiService = ContactService._init();

  factory ContactService() {
    return _apiService;
  }

  ContactService._init();

  //add new Contact
  Future<Response> addNewContact(Contact contact) async {
    final request = await http.post(
        Uri.http(
            Url,
            contactMethodConstants.ADD_NEW_contact +
                "/" +
                contact.name +
                "/" +
                contact.phone +
                "/" +
                contact.type +
                "/" +
                Home.currentUser.id),
        body: jsonEncode(contact.toJson()),
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

  Future<Response> addNewDoctor(
      String name, String phone, String specialty, String userid) async {
    final request = await http.post(
        Uri.http(
            Url,
            contactMethodConstants.ADD_NEW_doctor +
                "/" +
                name +
                "/" +
                phone +
                "/doctor/" +
                specialty +
                "/" +
                Home.currentUser.id),
        //body: jsonEncode(contact.toJson()),
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

  Future<Response> adddoc(
      String name, String phone, String specialty, String userid) async {
    final request = await http.post(
        Uri.http(
            Url,
            contactMethodConstants.ADD_NEW_doctor +
                "/" +
                name +
                "/" +
                phone +
                "/doctor/" +
                specialty +
                "/" +
                Home.currentUser.id),
        //body: jsonEncode(activity.toJson()),
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
  Future<List<ContactList>> getAllContacts(String userid) async {
    final request = await http.get(
        Uri.http(Url, contactMethodConstants.LIST_ALL_contactS + "/" + userid),
        headers: AppConstants.HEADERS);
    List<ContactList> list = [];
    try {
      if (request.statusCode == 200) {
        list = ContactListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<ContactList>();
    }
    return list;
  }

  Future<List<ContactList>> getAllDoctors(String userid) async {
    final request = await http.get(
        Uri.http(Url, contactMethodConstants.LIST_ALL_doctors + "/" + userid),
        headers: AppConstants.HEADERS);
    List<ContactList> list = [];
    try {
      if (request.statusCode == 200) {
        list = ContactListFromJson(request.body);
      } else {
        print(request.statusCode);
      }
    } catch (e) {
      return List<ContactList>();
    }
    return list;
  }

  //delete
  Future<Response> deleteContact(String id) async {
    //String json = '{"id" : "$id"}';
    final request = await http.get(
        Uri.http(Url, contactMethodConstants.DELETE_contact + "/" + id),
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
