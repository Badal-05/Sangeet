import 'dart:async';
import 'dart:convert';
import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// use functional programming when we require a function to return multiple types of values.
// here we used Either<> which requires the data type returned in case of failure first, and then in case of success.

part 'auth_remote_repo.g.dart';

// made a function that creates provider for authRemoteRepo, this is like a normal ref. It is used in authViewModel
@riverpod
AuthRemoteRepo authRemoteRepo(AuthRemoteRepoRef ref) {
  return AuthRemoteRepo();
}

class AuthRemoteRepo {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ServerConstants.serverUrl}/auth/signup',
        ),
        headers: {
          'Content-Type': 'application/json'
        }, //specifies the type of the content
        body: json.encode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
        ),
        //since we specified the type of the content to be a json, we can't send a map. To convert a map to json we used json.encode
      );
      final user = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        return Left(AppFailure(err: user['detail']));
      }

      return Right(UserModel.fromMap(user));
    } catch (e) {
      return Left(AppFailure(err: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ServerConstants.serverUrl}/auth/login',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      final user = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(err: user['detail']));
      }
      return Right(UserModel.fromMap(user));
    } catch (e) {
      return Left(AppFailure(err: e.toString()));
    }
  }
}
