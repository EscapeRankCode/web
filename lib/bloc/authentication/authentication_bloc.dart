import 'package:bloc/bloc.dart';
import 'package:flutter_escaperank_web/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserService _userService;

  AuthenticationBloc(UserService userService)
      : assert(userService != null),
        _userService = userService,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    else if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    else if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }

  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading();
    await Future.delayed(Duration(milliseconds: 1000));
    try {
      var prefs = await SharedPreferences.getInstance();
      //If no token saved
      if (prefs.getString("token") == null ||
          prefs.getString("token")!.isEmpty) {
        yield AuthenticationNotAuthenticated();
      } else {
        final currentUser = await _userService.getCurrentUser(prefs.getString("token") ?? "error");
        if (currentUser != null) {
          yield AuthenticationAuthenticated(user: currentUser);
        } else {
          prefs.clear();
          yield AuthenticationNotAuthenticated();
        }
      }
    } catch (e) {
      yield AuthenticationNotAuthenticated();
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
  //  final user = await _userService.getCurrentUser(event.token);
   // if (user != null) {
    //  yield AuthenticationAuthenticated(user: event.user, token: event.token);
   // }
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    //await _authenticationService.logOut("tokenfalso");
    yield AuthenticationNotAuthenticated();
  }
}