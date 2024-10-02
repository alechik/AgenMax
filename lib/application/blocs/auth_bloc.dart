import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignInEvent) {
      yield AuthLoading();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        yield AuthSuccess(user: userCredential.user);
      } catch (e) {
        yield AuthFailure(error: e.toString());
      }
    } else if (event is RegisterEvent) {
      yield AuthLoading();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        yield AuthSuccess(user: userCredential.user);
      } catch (e) {
        yield AuthFailure(error: e.toString());
      }
    }
  }
}
