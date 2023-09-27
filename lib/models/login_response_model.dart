import 'dart:convert';

import 'package:nbtour/models/role_model.dart';

LoginResponseModel loginResponseModel(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.msg,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
  late final String msg;
  late final String accessToken;
  late final String refreshToken;
  late final User user;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['accessToken'] = accessToken;
    _data['refreshToken'] = refreshToken;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
    required this.userId,
    required this.userName,
    required this.email,
    required this.birthday,
    required this.avatar,
    required this.address,
    required this.phone,
    required this.accessChangePassword,
    required this.userRole,
  });
  late final String userId;
  late final String userName;
  late final String email;
  late final DateTime birthday;
  late final String avatar;
  late final String address;
  late final String phone;
  late final int accessChangePassword;
  late final RoleModel userRole;

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    email = json['email'];
    birthday = json['birthday'];
    avatar = json['avatar'];
    address = json['address'];
    phone = json['phone'];
    accessChangePassword = json['accessChangePassword'];
    userRole = RoleModel.fromJson(json['user_role']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['userName'] = userName;
    _data['email'] = email;
    _data['birthday'] = birthday;
    _data['avatar'] = avatar;
    _data['address'] = address;
    _data['phone'] = phone;
    _data['accessChangePassword'] = accessChangePassword;
    _data['user_role'] = userRole.toJson();
    return _data;
  }
}
