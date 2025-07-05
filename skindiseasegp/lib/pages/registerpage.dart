import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:skindiseasegp/widgets/custombutton.dart';
import 'package:skindiseasegp/widgets/customtextfield.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});
  static String id = "registerpage";

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  String? email;
  String? password;
  String? username;
  String? gender;
  String? birthdate;
  GlobalKey<FormState> formkey = GlobalKey();
  bool isloading = false;

  TextEditingController birthdateController =
      TextEditingController(); // للتحكم في حقل التاريخ

  // دالة اختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdate = "${picked.year}-${picked.month}-${picked.day}";
        birthdateController.text = birthdate!; // تحديث الحقل بالبيانات
      });
    }
  }

  Future<void> registerUser() async {
    if (formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        isloading = true;
      });

      try {
        // إنشاء المستخدم في Firebase Auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        // حفظ البيانات في Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
          'birthdate': birthdate,
          'gender': gender,
        });

        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account registered successfully!")),
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        setState(() {
          isloading = false;
        });

        String errorMessage = "There was an error, try again later";
        if (e.code == 'email-already-in-use') {
          errorMessage = "This email is already in use";
        } else if (e.code == 'weak-password') {
          errorMessage = "The password is too weak";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email format is invalid";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An unexpected error occurred")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 244, 254, 254), // لون التدرج من الأعلى
              Color(0xFFFFF7EB), // لون التدرج من الأسفل
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Form(
            key: formkey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 35),
                const Center(
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Image.network(
                //   "https://assets-wp-cdn.onsurity.com/wp/wp-content/uploads/2024/07/31134009/top-health-insurance-companies-in-india.webp",
                //   width: double.infinity, // تحديد العرض
                //   fit: BoxFit.cover, // لضبط حجم الصورة داخل الإطار
                // ),

                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      " Register",
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Customtextfield(
                  obscuretext: false,
                  icon: const Icon(Icons.person),
                  hinttext: "Username",
                  onchanged: (data) {
                    username = data;
                  },
                ),
                const SizedBox(height: 10),
                Customtextfield(
                  obscuretext: false,
                  icon: const Icon(Icons.email),
                  hinttext: "Email",
                  onchanged: (data) {
                    email = data;
                  },
                ),
                const SizedBox(height: 10),
                Customtextfield(
                  obscuretext: true,
                  icon: const Icon(Icons.lock),
                  hinttext: "Password",
                  onchanged: (data) {
                    password = data;
                  },
                ),
                const SizedBox(height: 10),

                // حقل اختيار التاريخ
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    controller: birthdateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      hintText: "Birthdate",
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "required";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // قائمة اختيار الجنس
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.people),
                      hintText: "Gender",
                    ),
                    items: ["Male", "Female"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                    validator: (value) => value == null ? "required" : null,
                  ),
                ),

                const SizedBox(height: 25),
                Custombutton(
                  onTap: registerUser,
                  s: "Register",
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 98, 209),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
