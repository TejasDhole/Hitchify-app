import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/UserModel.dart';

Future<User> getAllUsers() async {
  User user = User();
  final response = await http.get(
    Uri.parse('http://localhost:8080/users'),
  );

  if (response.statusCode == 200) {
    user = User.fromJson(json.decode(response.body));

  } else {
    throw Exception('Failed to load rides');
  }

  return user;
}

Future<User> getUserById(String id) async {
  User user = User();
  final response = await http.get(
    Uri.parse('http://localhost:8080/users/$id'),
  );

  if (response.statusCode == 200) {
    user = User.fromJson(json.decode(response.body));

  } else {
    throw Exception('Failed to load rides');
  }

  return user;
}

Future<User> createUser(User user) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 201) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create user');
  }
}

Future<User> getUserByEmailorPhone(String email) async {
  User user = User();
  final response = await http.get(
    Uri.parse('http://localhost:8080/users?email=$email'),
  );

  if (response.statusCode == 200) {
    user = User.fromJson(json.decode(response.body));

  } else {
    throw Exception('Failed to load rides');
  }

  return user;
}
