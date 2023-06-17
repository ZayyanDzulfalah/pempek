class AccountModel {
  int? id;
  String? name, email, password, role;

  AccountModel({this.id, this.name, this.email, this.password, this.role});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
