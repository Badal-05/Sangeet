import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repo.dart';
import 'package:client/features/auth/repositories/auth_remote_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  //final AuthRemoteRepo _authRemoteRepo = AuthRemoteRepo();

  // we didn't use the above line because we need to add it into the build function,
  // this way everytime the build function gets called we update the value of _authRemoteRepo;
  late AuthRemoteRepo _authRemoteRepo;
  late AuthLocalRepo _authLocalRepo;

  @override
  AsyncValue<UserModel>? build() {
    //we have used async value to represent all the states. Data, loading, error
    _authRemoteRepo = ref.watch(authRemoteRepoProvider);
    _authLocalRepo = ref.watch(authLocalRepoProvider);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepo.init();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepo.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.err,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepo.login(
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.err, StackTrace.current),
      // fpdart.Right(value: final r) => state = AsyncValue.data(r)
      // here we wanted to set token along with setting the data, but we cannot use block functions in pattern matching so we used a function.
      Right(value: final r) => _loginSuccess(r),
    };
    print(val);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepo.setToken(user.token);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepo.getToken();
    if (token != null) {
      final res = await _authRemoteRepo.getCurrentUserData(token);
      final val = switch (res) {
        Left(value: final l) => state =
            AsyncValue.error(l.err, StackTrace.current),
        Right(value: final r) => state = AsyncValue.data(r),
      };
      return val.value;
    }
    return null;
  }
}
