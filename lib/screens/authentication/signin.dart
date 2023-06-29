import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInWidget extends StatefulWidget {
  const GoogleSignInWidget({super.key});

  @override
  _GoogleSignInWidgetState createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      // Signed in successfully, handle the user authentication
      // You can access user information using _googleSignIn.currentUser
      // For example, _googleSignIn.currentUser.displayName provides the user's display name
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle sign-in error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _handleSignIn,
        child: const Text('Sign in with Google'),
      ),
    );
  }
}
