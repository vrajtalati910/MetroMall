class LoginResponse {
  String? message;
  Data? data;
  String? token;
  String? status;

  LoginResponse({this.message, this.data, this.token, this.status});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    token = json['token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
    data['status'] = status;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? role;

  Data({this.id, this.name, this.email, this.role});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}
