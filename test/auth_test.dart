import 'package:comingsoon/services/auth/auth_exceptions.dart';
import 'package:comingsoon/services/auth/auth_provider.dart';
import 'package:comingsoon/services/auth/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mock authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialised to begin with', () {
      expect(provider.isInitialised, false);
    });
    test('Should not log out if not initialised', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitialisedExeption>()));
    });
    test('Should be able to be initialised', () async {
      await provider.initialize();
      expect(provider.isInitialised, true);
    });
    test('User should be null after intitialisation', () {
      expect(provider.currentUser, null);
    });
    test(
      'Should not be initialised in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialised, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
          email: 'allennellasorry@gmail.com', password: 'any');
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser =
          provider.createUser(email: 'someone@gmail.com', password: 'Nella12*');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await provider.createUser(
          email: 'someone@gmail.com', password: 'Dog');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
    test('Login user should be varified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
  });
}

class NotInitialisedExeption implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialised = false;
  bool get isInitialised => _isInitialised;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialised) throw NotInitialisedExeption();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialised = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialised) throw NotInitialisedExeption();
    if (email == 'allennellasorry@gmail.com') throw UserNotFoundAuthException();
    if (password == 'Nella12*') throw WrongPasswordAuthException();
    final user = AuthUser(
      isEmailVerified: false,
      email: email,
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialised) throw NotInitialisedExeption();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialised) throw NotInitialisedExeption();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    final newUser = AuthUser(
      isEmailVerified: true,
      email: user.email,
    );
    _user = newUser;
  }

  @override
  AuthUser? get currentUser => _user;
}
