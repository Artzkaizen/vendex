import 'package:vendx/features/auth/model/user_model.dart';

class AuthModel {
  final String jwt;
  final User user;

  AuthModel({
    required this.jwt,
    required this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _authModelFromJson(json);

  Map<String, dynamic> toJson() => _authModelToJson(this);
  static AuthModel _authModelFromJson(Map<String, dynamic> json) {
    return AuthModel(
      jwt: json['jwt'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> _authModelToJson(AuthModel instance) {
    return {
      'jwt': instance.jwt,
      'user': instance.user.toJson(),
    };
  }
}
