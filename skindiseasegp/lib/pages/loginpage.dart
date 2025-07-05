import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skindiseasegp/pages/homepage.dart';
import 'package:skindiseasegp/pages/newspage.dart';
import 'package:skindiseasegp/pages/registerpage.dart';
import 'package:skindiseasegp/widgets/custombutton.dart';
import 'package:skindiseasegp/widgets/customtextfield.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  static String id = 'loginpage'; // Route name

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String? email;
  String? password;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 232, 163, 186),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 235, 248, 249), // لون التدرج من الأعلى
              Color(0xFFFFF7EB), // لون التدرج من الأسفل
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Tinos',
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //Center(
                //child: Image.asset("images/health.webp"),
                //),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Text(
                      " Login",
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        //
                      ),
                    ),
                  ],
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
                const SizedBox(height: 25),
                Custombutton(
                  s: "Login",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );

                        setState(() {
                          isLoading = false;
                        });
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login successful!")),
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, Homepage.id);
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          isLoading = false;
                        });

                        String errorMessage =
                            "There was an error, try again later";

                        if (e.code == 'user-not-found') {
                          errorMessage = "No user found with this email";
                        } else if (e.code == 'wrong-password') {
                          errorMessage = "Incorrect password";
                        } else if (e.code == 'invalid-email') {
                          errorMessage = "Invalid email format";
                        }
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("An unexpected error occurred")),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, Registerpage.id); // Correct route name
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 109, 199)),
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
