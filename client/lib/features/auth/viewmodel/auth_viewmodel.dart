import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repo.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  //final AuthRemoteRepo _authRemoteRepo = AuthRemoteRepo();

  // we didn't use the above line because we need to add it into the build function,
  // this way everytime the build function gets called we update the value of _authRemoteRepo;
  late AuthRemoteRepo _authRemoteRepo;

  @override
  AsyncValue<UserModel>? build() {
    //we have used async value to represent all the states. Data, loading, error
    _authRemoteRepo = ref.watch(authRemoteRepoProvider);
    return null;
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
      fpdart.Left(value: final l) => state = AsyncValue.error(
          l.err,
          StackTrace.current,
        ),
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
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
      fpdart.Left(value: final l) => state =
          AsyncValue.error(l.err, StackTrace.current),
      fpdart.Right(value: final r) => state = AsyncValue.data(r)
    };
    print(val);
  }
}
