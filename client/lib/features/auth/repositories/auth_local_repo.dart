import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repo.g.dart';

// initially we had @riverpod. we change it beacuse the notifier was  autoDispose, hence whenever we called the ref.watch(_authLocalRepo)
// a new instance of authLocalRepo was being created. That caused the exception of _sharedPreferences not initialized.

// so to resovle that issue we used this thing, which never disposes the instance of the _authLocalProvider hence we work our way around the error.
@Riverpod(keepAlive: true)
AuthLocalRepo authLocalRepo(AuthLocalRepoRef ref) {
  return AuthLocalRepo();
}

class AuthLocalRepo {
  late SharedPreferences _sharedPreferences;
  //we made the variable late because the SharedPreferences.getInstance() returns a future value.
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // now since this is a late variable we need to call it first before calling the get/set token function, otherwise it will not be initialized.
  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
