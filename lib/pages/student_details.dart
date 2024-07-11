import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentDetails extends StatefulWidget {
  final String sid;
  const StudentDetails({super.key, required this.sid});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  Future<DocumentSnapshot> getStudentDetails() async {
    return await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.sid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getStudentDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Student not found'));
          } else {
            var studentData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          color: Colors.grey[300]),
                      height: 100,
                      width: 100,
                      child: const Icon(
                        Icons.person,
                        size: 70,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text('Full Name: ${studentData['fullName']}',
                        style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 10),
                    Text('Date of Birth: ${studentData['dateOfBirth']}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Gender: ${studentData['gender']}',
                        style: const TextStyle(fontSize: 18)),
                    // Add more fields as needed
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
