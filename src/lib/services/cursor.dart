// Dart imports:
import 'dart:convert' as convert;

// Flutter imports:
import 'package:flutter/foundation.dart' as foundation;

// Package imports:
import 'package:http/http.dart' as http;

class Cursor {
  static const String endpoint = foundation.kReleaseMode
      ? 'https://flutter-blog-app.herokuapp.com'
      : 'http://127.0.0.1:5000';

  static const Map<String, String> headers = {
    'Authorization': '12345',
  };

  static Future<Map> getUser(String username) async {
    Uri url = Uri.parse("$endpoint/users?username=$username");
    http.Response response = await http.get(url);
    return convert.jsonDecode(response.body);
  }

  static Future<Map> insertUser(
    String name,
    String username,
    String email,
    String password,
  ) async {
    Uri url = Uri.parse("$endpoint/users");
    http.Response response = await http.post(
      url,
      headers: headers,
      body: {
        'username': username,
        'name': name,
        'email': email,
        'password': password,
      },
    );
    return convert.jsonDecode(response.body);
  }

  static Future<Map> updateUser(Map user) async {
    Uri url = Uri.parse("$endpoint/users");
    http.Response response = await http.patch(
      url,
      headers: headers,
      body: user,
    );
    return convert.jsonDecode(response.body);
  }

  static Future<List> getPosts({int? authorId}) async {
    Uri url;
    if (authorId != null) {
      url = Uri.parse("$endpoint/posts?author_id=$authorId");
    } else {
      url = Uri.parse("$endpoint/posts");
    }
    http.Response response = await http.get(url);
    return convert.jsonDecode(response.body);
  }

  static Future<Map> publishPost(Map post) async {
    Uri url = Uri.parse("$endpoint/posts");
    http.Response response = await http.post(
      url,
      body: post,
      headers: headers,
    );
    return convert.jsonDecode(response.body);
  }

  static Future<Map> deletePost(int postId) async {
    Uri url = Uri.parse("$endpoint/posts");
    http.Response response = await http.delete(
      url,
      body: {
        'post_id': postId.toString(),
      },
      headers: headers,
    );
    return convert.jsonDecode(response.body);
  }



  static Future<Map> editPost(Map post) async {
    Uri url = Uri.parse("$endpoint/posts");
    http.Response response = await http.patch(
      url,
      headers: headers,
      body: post,
    );
    return convert.jsonDecode(response.body);
  }
}
