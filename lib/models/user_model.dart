// user_id, user_name, email, password, birthday, avatar, address, phone, accessChangePassword, refresh_token, role_id, status
import 'package:nbtour/models/role_model.dart';

List<UserModel> usersFromJson(dynamic str) =>
    List<UserModel>.from((str).map((x) => UserModel.fromJson(x)));

// List<UserModel> usersFromJson(dynamic str) {

//   final rows = str['rows'];

//   return List<UserModel>.from(rows.map((x) => UserModel.fromJson(x)));
// }

class UserModel {
  late String? id;
  late String? name;
  late String? email;
  late DateTime? yob;
  late String? avatar;
  late String? address;
  late String? phone;
  late int? maxTour;
  late bool? accessChangePassword;
  late RoleModel? roleModel;
  late String? status;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.yob,
    this.avatar,
    this.address,
    this.phone,
    this.accessChangePassword,
    this.roleModel,
    this.maxTour,
    this.status,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['userId'];
    name = json['userName'];
    email = json['email'];
    yob = json['birthday'];
    avatar = json['avatar'];
    address = json['address'];
    phone = json['phone'];
    maxTour = json['maxTour'];
    accessChangePassword = json['accessChangePassword'];
    roleModel = json['role_model'] != null
        ? RoleModel.fromJson(json['role_model'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = id;
    data['userName'] = name;
    data['email'] = email;
    data['birthday'] = yob;
    data['avatar'] = avatar;
    data['address'] = address;
    data['maxTour'] = maxTour;
    data['phone'] = phone;
    data['accessChangePassword'] = accessChangePassword;
    if (roleModel != null) {
      data['role_model'] = roleModel!.toJson();
    }
    data['status'] = status;
    return data;
  }
}
