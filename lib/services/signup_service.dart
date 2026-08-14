import 'package:firebase_auth/firebase_auth.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUser(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Create Firebase account
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get created user
      User? user = userCredential.user;

      // Save username in Firebase Authentication profile
      if (user != null) {
        await user.updateDisplayName(name);

        // Refresh user information
        await user.reload();

        user = _auth.currentUser;
      }

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception(
            'This email is already registered.',
          );

        case 'invalid-email':
          throw Exception(
            'Please enter a valid email address.',
          );

        case 'weak-password':
          throw Exception(
            'Password is too weak.',
          );

        case 'operation-not-allowed':
          throw Exception(
            'Email/Password authentication is not enabled.',
          );

        case 'network-request-failed':
          throw Exception(
            'Network error. Check your internet connection.',
          );

        default:
          throw Exception(
            e.message ?? 'Signup failed.',
          );
      }
    } catch (e) {
      throw Exception(
        'Something went wrong. Please try again.',
      );
    }
  }
}