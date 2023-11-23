typedef UserType = Map<String, dynamic>;

class ReqUser {
  final String? email;
  final String? password;

  const ReqUser({required this.email, required this.password});

  factory ReqUser.fromJson(UserType json) => ReqUser(
        email: json['email'],
        password: json['password'],
      );
  UserType toJson() => {'email': email, 'password': password};
}
