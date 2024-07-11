import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kudosware_firebase/common_elements.dart';
import 'package:kudosware_firebase/pages/add_student_page.dart';
import 'package:kudosware_firebase/pages/login_page.dart';
import 'package:kudosware_firebase/pages/student_details.dart';
import 'package:kudosware_firebase/services/auth_service.dart';
import 'package:kudosware_firebase/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Students' Data"),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: "Logout",
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await AuthService().signOut();

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            child: const Text("PROCEED"),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder(
            future: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingStudentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return const Center(child: Text('No students found'));
              } else {
                var students = snapshot.data.docs;
                return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      var student = students[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              student['fullName'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date of Birth: ${student['dateOfBirth']}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "Gender: ${student['gender']}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            onTap: () {
                              nextScreen(
                                  context, StudentDetails(sid: student.id));
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    });
              }
            }),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(20),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            nextScreen(context, const AddStudentPage());
          },
          child: const Icon(Icons.person_add_alt_1),
        ));
  }
}
