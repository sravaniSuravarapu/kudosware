import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kudosware_firebase/helpers/helper_function.dart';
import 'package:kudosware_firebase/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginUserWithEmailAndPassword(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        if (user.emailVerified) {
          return true;
        } else {
          await firebaseAuth.signOut();
          return "Please verify your email before logging in.";
        }
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);

        await user.sendEmailVerification();

        await Future.delayed(const Duration(minutes: 1));

        await user.reload();
        user = firebaseAuth.currentUser;

        if (user != null && user.emailVerified) {
          return true;
        } else {
          await user?.delete();
          return "Email not verified. User account has been deleted.";
        }
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future saveStudentDataInDB(
      String uid, String fullName, DateTime dateOfBirth, String gender) async {
    try {
      await DatabaseService(uid: uid).saveStudentData(
          fullName, DateFormat('yyyy-MM-dd').format(dateOfBirth), gender);
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSP("");
      await HelperFunctions.saveUserNameSP("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
