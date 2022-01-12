// To parse this JSON data, do
//
//     final failure = failureFromJson(jsonString);

import 'dart:convert';

enum FailureStatus {
  SocketException,
  Timeout,
  HttpError,
  FormatException,
  //this are error sent from the server
  // eg 400 .-> user already exist
  ServerCommunication,
}

// Failure failureFromJson(String str) => Failure.fromJson(json.decode(str));

String failureToJson(Failure data) => json.encode(data.toJson());

class Failure {
  Failure({
    required this.message,
    required this.status,
    required this.title,
  });

  late String message;
  late String title;
  late FailureStatus status;
  bool get isInternetConnectionError => status == FailureStatus.SocketException;
  // when you want to pass other exception
  // factory Failure.fromJson(String message, FailureStatus status) => Failure(
  //       title: ,
  //       message: message,
  //       status: status,
  //     );
  factory Failure.socketException() => Failure(
        title: "No internet connection",
        message: "Please, check your ineternet connection and try again",
        status: FailureStatus.SocketException,
      );
  factory Failure.timeout() => Failure(
        title: "No internet connection",
        message: "Please, check your ineternet connection and try again",
        status: FailureStatus.Timeout,
      );
  factory Failure.formatException() => Failure(
        title: "Bad response format",
        message: "Please, check entry and try again",
        status: FailureStatus.FormatException,
      );
  factory Failure.httpException() => Failure(
        title: "404",
        message: "Does not exist",
        // Couldn't find
        status: FailureStatus.SocketException,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
      };
}
