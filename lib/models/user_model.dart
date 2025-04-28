class UserModel {
  final int id;
  final String? name;
  final String? email;
  final String? phone;

  UserModel({required this.id, this.name, this.email, this.phone});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
}
