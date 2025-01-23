part of 'auth_bloc.dart';

// @freezed
// class AuthEvent with _$AuthEvent {
//   const factory AuthEvent.login(
//       {required String email, required String password}) = LoginEvent;
//   const factory AuthEvent.signup(
//       {required String email, required String password}) = SignupEvent;
//   const factory AuthEvent.logout() = LogoutEvent;
//   const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;
// }

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _Started;
  const factory AuthEvent.login({required String email, required String password}) = _Login;
  const factory AuthEvent.logout() = _Logout;
}
