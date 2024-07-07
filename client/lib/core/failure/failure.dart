// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppFailure {
  final String err;
  AppFailure({this.err = 'Sorry, an unexpected error occured!'});

  @override
  String toString() => 'AppFailure(err: $err)';
}
