import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection("students");

  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "profilePic": "",
      "uid": uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();

    return snapshot;
  }

  Future saveStudentData(
      String fullName, String? dateOfBirth, String gender) async {
    return await studentsCollection.add({
      "fullName": fullName,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "created_by": uid,
    });
  }

  Future gettingStudentData() async {
    QuerySnapshot snapshot =
        await studentsCollection.where("created_by", isEqualTo: uid).get();

    return snapshot;
  }
}
