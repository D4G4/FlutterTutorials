/// This is a simple model class
import 'package:firebase_auth/firebase_auth.dart';

class AppState {
  bool isLoading;
  FirebaseUser user;

  AppState({
    this.isLoading = false,
    this.user,
  });

  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() =>
      'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}';
}
