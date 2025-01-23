import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/domain/auth/auth_repository.dart';
import 'package:restaurant_app/domain/model/user/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    //   on<LoginEvent>(_onLoginEvent);
    //   on<SignupEvent>(_onSignupEvent);
    //   on<LogoutEvent>(_onLogoutEvent);
    //   on<CheckAuthStatus>(_onCheckAuthStatusEvent);
    // }

    // Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    //   emit(const AuthState.loading());
    //   try {
    //     final token = await _authRepository.login(
    //         email: event.email, password: event.password);
    //     emit(AuthState.authenticated(token));
    //   } catch (e) {
    //     emit(AuthState.error(e.toString()));
    //   }
    // }

    // void _onSignupEvent(SignupEvent event, Emitter<AuthState> emit) async {
    //   emit(const AuthState.loading());
    //   try {
    //     await _authRepository.signup(
    //         email: event.email, password: event.password);
    //     emit(const AuthState.unauthenticated());
    //   } catch (e) {
    //     emit(AuthState.error(e.toString()));
    //   }
    // }

    // Future<void> _onLogoutEvent(
    //     LogoutEvent event, Emitter<AuthState> emit) async {
    //   await _authRepository.logout();
    //   emit(const AuthState.unauthenticated());
    // }

    // void _onCheckAuthStatusEvent(
    //     CheckAuthStatus event, Emitter<AuthState> emit) async {
    //   emit(const AuthState.loading());
    //   final isAuthenticated = await _authRepository.isAuthenticated();
    //   if (isAuthenticated) {
    //   final token = await _authRepository.getToken();
    //     emit(AuthState.authenticated(token)); // Token can be passed here
    //   } else {
    //     emit(const AuthState.unauthenticated());
    //   }

    on<AuthEvent>((event, emit) async {
      await event.map(
        started: (e) async{
          emit(const AuthState.loading());
          try {
            final user = await _authRepository.checkAuthStatus();
            if (user != null) {
              emit(AuthState.authenticated(user));
            } else {
              emit(const AuthState.unauthenticated());
            }
          } catch (e) {
            emit(const AuthState.unauthenticated());
          }
        },
        login: (e) async{
          emit(const AuthState.loading());
          try {
            final user = await _authRepository.login(e.email,  e.password);
            emit(AuthState.authenticated(user));
          } catch (error) {
            emit(AuthState.error(error.toString()));
          }
        },
        logout: (e) async{
          emit(const AuthState.loading());
          await _authRepository.logout();
          emit(const AuthState.unauthenticated());
        },
      );
    });
  }
}
