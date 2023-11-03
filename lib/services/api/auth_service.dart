import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:nbtour/services/api/config.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static var client = http.Client();
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  static void printWrapped(String text) =>
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // User canceled the sign-in
        return false;
      }
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        FirebaseAuth fAuth = FirebaseAuth.instance;
        final User? firebaseUser = (await fAuth
                .signInWithCredential(authCredential)
                // ignore: body_might_complete_normally_catch_error
                .catchError((msg) {}))
            .user;
        if (firebaseUser != null) {
          String? token = await firebaseUser.getIdToken();
          printWrapped('Get token from firebase: $token');
          await sendTokenToApi(token!);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('tokenfirebase', token);
          print(token);
          return true;
        } else {
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      printWrapped('error: ${e.message}');
      return false;
    }
    return false;
  }

  // static Future<bool> login(LoginRequestModel model) async {
  //   Map<String, String> requestHeaders = {
  //     'Content-Type': 'application/json',
  //   };

  //   const url = 'https://nbtour-fc9f59891cf4.herokuapp.com/api/v1/auth/login';

  //   var response = await http.post(Uri.parse(url),
  //       headers: requestHeaders, body: jsonEncode(model.toJson()));
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {}
  // }

  Future<int> signInWithUserNameAndPassword(
      String emailInput, String password) async {
    var url = Uri.https(Config.apiURL, Config.login);
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'email': emailInput,
      'password': password,
    });
    final response = await client.post(url, headers: headers, body: body);
    final responseData = json.decode(response.body);

    final accesstoken = responseData['accessToken'];

    if (response.statusCode == 200) {
      final name = responseData['user']['userName'];
      final phone = responseData['user']['phone'];
      final email = responseData['user']['email'];
      final idUser = responseData['user']['userId'];
      final roleId = responseData['user']['user_role']['roleId'];
      final roleName = responseData['user']['user_role']['roleName'];
      final yob = responseData['user']['birthday'];
      final address = responseData['user']['address'];
      final accessChangePassword = responseData['user']['accessChangePassword'];
      final avatar = responseData['user']['avatar'];
      final status = responseData['user']['status'];

      // Lưu trữ access token bằng Shared Preferences
      if (accesstoken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accesstoken', accesstoken);
        printWrapped(accesstoken);
      }
      if (idUser != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', idUser);
      }
      if (name != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', name);
      }

      if (phone != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone', phone);
      }
      if (email != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
      }
      if (roleId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role_id', roleId);
      }
      if (roleName != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role_name', roleName);
      }
      if (yob != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('birthday', yob);
      }
      if (address != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('address', address);
      }
      if (accessChangePassword != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('accessChangePassword', accessChangePassword);
      }
      if (avatar != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatar', avatar);
      }
      if (status != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('status', status);
      }

      // Rest of your code...
    } else {
      return json.decode(response.body)['msg'];
    }
    return response.statusCode;
  }

  Future<void> sendTokenToApi(String token) async {
    var url = Uri.https(Config.apiURL, Config.loginGoogle);

    // ignore: non_constant_identifier_names
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      'tokenfirebase': token,
    });
    final response = await client.post(url, headers: headers, body: body);
    final responseData = json.decode(response.body);
    final accesstoken = responseData['accessToken'];
    printWrapped('AcessToken: $accesstoken');
    printWrapped('Token đã được gửi lên API. Dữ liệu trả về: $responseData');

    if (response.statusCode == 200) {
      final name = responseData['user']['userName'];
      final phone = responseData['user']['phone'];
      final email = responseData['user']['email'];
      final idUser = responseData['user']['userId'];
      final roleId = responseData['user']['user_role']['roleId'];
      final roleName = responseData['user']['user_role']['roleName'];
      final yob = responseData['user']['birthday'];
      final address = responseData['user']['address'];
      final accessChangePassword = responseData['user']['accessChangePassword'];
      final avatar = responseData['user']['avatar'];
      final status = responseData['user']['status'];

      // Lưu trữ access token bằng Shared Preferences
      if (accesstoken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accesstoken', accesstoken);
        printWrapped(accesstoken);
      }
      if (idUser != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', idUser);
      }
      if (name != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', name);
      }

      if (phone != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone', phone);
      }
      if (email != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
      }
      if (roleId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role_id', roleId);
      }
      if (roleName != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role_name', roleName);
      }
      if (yob != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('birthday', yob);
      }
      if (address != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('address', address);
      }
      if (accessChangePassword != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('accessChangePassword', accessChangePassword);
      }
      if (avatar != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatar', avatar);
      }
      if (status != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('status', status);
      }

      // Rest of your code...
    } else {
      return json.decode(response.body)['msg'];
    }
  }

  Future<void> signOut(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      var url =
          'https://nbtour-fc9f59891cf4.herokuapp.com/api/v1/auth/logout?userId=$userId';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        await googleSignOut();
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (error) {
      // Handle the error here, e.g., print it for debugging purposes.
    }
  }

  googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
