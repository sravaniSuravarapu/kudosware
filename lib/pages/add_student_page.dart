import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudosware_firebase/common_elements.dart';
import 'package:kudosware_firebase/pages/home_page.dart';
import 'package:kudosware_firebase/services/auth_service.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final formKey = GlobalKey<FormState>();
  String fullName = "";
  DateTime? dateOfBirth;
  String? gender;
  bool _isLoading = false;

  final List<String> genders = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Add Student Data",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Full Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fullName = value;
                          });
                        },
                        validator: (value) =>
                            value!.isNotEmpty ? null : "Name cannot be empty.",
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        readOnly: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Date of Birth",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dateOfBirth = pickedDate;
                            });
                          }
                        },
                        validator: (value) => dateOfBirth != null
                            ? null
                            : "Please select your date of birth.",
                        controller: TextEditingController(
                          text: dateOfBirth == null
                              ? ""
                              : DateFormat('yyyy-MM-dd').format(dateOfBirth!),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Gender",
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        value: gender,
                        items: genders.map((String gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        validator: (value) =>
                            value != null ? null : "Please select your gender.",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          onPressed: () {
                            addStudentData();
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  addStudentData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await AuthService()
          .saveStudentDataInDB(FirebaseAuth.instance.currentUser!.uid, fullName,
              dateOfBirth!, gender!)
          .then((value) => {
                if (value == true)
                  {
                    showSnackBar(context, Colors.green,
                        "Student data added successfully!"),
                    nextScreenReplacement(context, const HomePage()),
                  }
                else
                  {showSnackBar(context, Colors.red, value)}
              });

      setState(() {
        _isLoading = false;
      });
    }
  }
}
