import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:network_service_setup/constants/Api_routes.dart';
import 'package:network_service_setup/models/failure.dart';

class NetworkClient {
  final String _baseUrl = BaseUrl;

  String formatQuery(Map queryParameters) {
    /// add a default parameter [device]
    /// then convert the map object to String
    /// using apporpriate symbols
    return {
      ...{"device": Platform.isAndroid ? "Android" : "IOS"},
      ...queryParameters,
    }
        .toString()
        .replaceAll(" ", "")
        .replaceAll(":", "=")
        .replaceAll(",", "&")
        .replaceAll("{", "")
        .replaceAll("}", "");
  }

  Future<T> get<T>(
    /// the api route without the base url
    /// e.g [v2/api/follow]
    ///
    String uri, {

    ///this are query parameters that would
    /// be attached to the url
    /// [e.g]=>{"a":"yes"}
    /// she.com/getPeople?a=yes
    Map<String, dynamic> queryParameters = const {},
  }) async {
    try {
      // covert map to string apporpriate for query parameters
      String _queryParametersString = formatQuery(queryParameters);

      Uri url = Uri.parse("$_baseUrl$uri?$_queryParametersString");
      http.Response response = await http.get(url);
      checkRequest(response);
      return json.decode(response.body);
    } on SocketException {
      throw Failure.socketException();
    } on HttpException {
      throw Failure.httpException();
    } on FormatException {
      throw Failure.formatException();
    } on TimeoutException {
      throw Failure.timeout();
    }
  }

  Future<dynamic> post(
    /// the api route without the base url
    /// e.g [v2/api/follow]
    ///
    String uri, {

    ///this are query parameters that would
    /// be attached to the url
    /// [e.g]=>{"a":"yes"}
    /// she.com/getPeople?a=yes
    Map<String, dynamic> queryParameters = const {},
    Object? body,
  }) async {
    try {
      String _queryParametersString = formatQuery(queryParameters);

      Uri url = Uri.parse("$_baseUrl$uri?$_queryParametersString");
      http.Response response = await http.post(
        url,
        body: body,
      );
      checkRequest(response);
      return json.decode(response.body);
    } on SocketException {
      throw Failure.socketException();
    } on HttpException {
      throw Failure.httpException();
    } on FormatException {
      throw Failure.formatException();
    } on TimeoutException {
      throw Failure.timeout();
    }
  }

  checkRequest(http.Response response) {
    switch (response.statusCode) {

      ///You can add and edit the cases
      ///depending on you use case
      case 200:
      case 201:
        return;
      case 401:
        throw Failure(
          title: "Unauthorized",
          message: "You do not have access to this functionality",
          status: FailureStatus.ServerCommunication,
        );
      default:
        // print(response.body);
        Map result = json.decode(response.body);

        // if(result.)
        throw Failure(
          title: "Error",
          message: result["message"],
          status: FailureStatus.ServerCommunication,
        );
    }
  }
}
