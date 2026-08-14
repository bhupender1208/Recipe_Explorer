import 'package:firebase_auth/firebase_auth.dart'; 

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginUser(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception(
            'No account found with this email.',
          );

        case 'wrong-password':
        case 'invalid-credential':
          throw Exception(
            'Invalid email or password.',
          );

        case 'invalid-email':
          throw Exception(
            'Please enter a valid email address.',
          );

        case 'user-disabled':
          throw Exception(
            'This account has been disabled.',
          );

        case 'network-request-failed':
          throw Exception(
            'Network error. Check your internet connection.',
          );

        default:
          throw Exception(
            e.message ?? 'Login failed.',
          );
      }
    } 
     
  }

  Future<void> logout() async {
    
    await _auth.signOut();
  }
}