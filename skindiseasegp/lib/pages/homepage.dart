import 'package:flutter/material.dart';
import 'package:skindiseasegp/pages/history.dart';
import 'package:skindiseasegp/pages/loginpage.dart';
import 'package:skindiseasegp/pages/newspage.dart';
import 'package:skindiseasegp/pages/profile.dart';
import 'package:skindiseasegp/pages/skindiseaseprediction.dart';
import 'package:skindiseasegp/widgets/menuitemcard.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
  static String id = 'homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            "MAIN MENU",
            // ignore: unnecessary_const
            style: const TextStyle(
              //fontFamily: 'Tinos',
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 255, 255, 255),
              letterSpacing: 1.2,
            ),
          ),
        ),
        elevation: 10,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 248, 253, 247),
              Color(0xFFFFF7EB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            //Image.asset("images/health.webp"),
            const SizedBox(height: 30),
            // شبكة الأزرار
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // عدد الأعمدة
                crossAxisSpacing: 20, // المسافة الأفقية بين العناصر
                mainAxisSpacing: 40, // المسافة الرأسية بين العناصر
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Menuitemcard(
                    icon: Icons.person,
                    onTab: () {
                      Navigator.pushNamed(context, Profile.id);
                    },
                    color: const Color.fromARGB(255, 0, 105, 224),
                    text: "Profile",
                  ),
                  Menuitemcard(
                    icon: Icons.health_and_safety,
                    onTab: () {
                      Navigator.pushNamed(context, SkinDiseasePrediction.id);
                    },
                    color: const Color.fromARGB(255, 50, 150, 0),
                    text: "Skin Detection",
                  ),
                  Menuitemcard(
                    icon: Icons.history,
                    onTab: () {
                      Navigator.pushNamed(context, HistoryScreen.id);
                    },
                    color: const Color.fromARGB(255, 32, 100, 9),
                    text: "History",
                  ),
                  Menuitemcard(
                    icon: Icons.newspaper,
                    onTab: () {
                      Navigator.pushNamed(context, Newspage.id);
                    },
                    color: const Color.fromARGB(255, 143, 108, 14),
                    text: "News",
                  ),
                ],
              ),
            ),
            // زرار Sign Out في النص
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Loginpage.id);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 0, 0,
                        0), // Updated container color                // 255, 2, 34, 70)
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Adds a subtle shadow
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Adjusted padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Aligns icon to the right
                      children: [
                        Text(
                          "Sign Out",
                          style: const TextStyle(
                            // fontFamily: 'Tinos',
                            fontSize: 30,
                            // fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Icon(Icons.logout,
                            color: Colors.white,
                            size: 30), // Icon color changed to white
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
