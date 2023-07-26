import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

class Auth {
  static Future<User?> loginUser (String email, String password) async {
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential u = await auth.signInWithEmailAndPassword(email: email, password: password);
      return u.user;
    }catch (e){
      print(e);
      return null;
    }
  }

  static Future<User?> loginWithGoogle () async {
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential u = await auth.signInWithCredential(credential);
      return u.user;
    }catch (e){
      print(e);
      return null;
    }
  }
}