import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currerntUser;
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
