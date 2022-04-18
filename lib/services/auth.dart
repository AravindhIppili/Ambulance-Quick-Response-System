import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AppUser? _userFromFB(User? user) {
    if (user == null) return null;
    return AppUser(user.uid, user.email);
  }

  String get email => _firebaseAuth.currentUser!.email.toString();

  Stream<AppUser?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFB);
  }

  Future<void> singOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<AppUser?> signIn(
      {required String email, required String password}) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFB(cred.user);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}
