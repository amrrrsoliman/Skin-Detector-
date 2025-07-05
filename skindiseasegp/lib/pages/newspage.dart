import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skindiseasegp/pages/profile.dart';

import 'history.dart';
import "skindiseaseprediction.dart"; // Import the Profile page

class Newspage extends StatefulWidget {
  const Newspage({super.key});
  static String id = 'Newspage';

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  List<dynamic> newsArticles = []; // List to store news articles
  bool isLoading = true; // Loading state
  String errorMessage = ''; // Error message

  @override
  void initState() {
    super.initState();
    fetchNews(); // Fetch news when the page loads
  }

  // Function to fetch news from the API
  Future<void> fetchNews() async {
    const String apiKey =
        'f16ea0939e554da1813f88a99a326dbb'; // Replace with your NewsAPI key
    const String query = 'dermatology'; // Query for skin disease news
    const String url =
        'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the API call is successful, parse the JSON
        final data = json.decode(response.body);
        setState(() {
          newsArticles = data['articles']; // Store the articles
          isLoading = false; // Stop loading
        });
      } else {
        // If the API call fails, throw an error
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load news: $e'; // Set error message
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            'News',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        centerTitle: true,
      ),
      // Add a Drawer (Menu Bar)
      /*drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 150),
          children: [
            // Menu Items
            ListTile(
              leading:
                  const Icon(Icons.person, color: Colors.blue), // Profile icon
              title: const Text(
                'My Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Navigate to the Profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
            ),
            const Divider(), // Add a divider for visual separation

            ListTile(
              leading: const Icon(Icons.health_and_safety, color: Colors.red),
              title: const Text(
                'SkinDiseasePrediction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Navigate to the Profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SkinDiseasePrediction(),
                  ),
                );
              },
            ),
            const Divider(), // Add a divider for visual separation

            ListTile(
              leading: const Icon(Icons.history,
                  color: Color.fromARGB(255, 171, 101, 106)),
              title: const Text(
                'history',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Navigate to the Profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(),
                  ),
                );
              },
            ),
            const Divider(), // Add a divider for visual separation
            ListTile(
              leading: const Icon(Icons.home, color: Colors.green), // Home icon
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Close the drawer and stay on the home page
                Navigator.pop(context);
              },
            ),
            const Divider(), // Add a divider for visual separation
            ListTile(
              leading:
                  const Icon(Icons.logout, color: Colors.red), // Logout icon
              title: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                // Sign out the user
                await FirebaseAuth.instance.signOut();
                // Navigate back to the login page
                Navigator.pushReplacementNamed(context, 'loginpage');
              },
            ),
          ],
        ),
      ),*/
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) // Show error message
              : Container(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: newsArticles.length,
                    itemBuilder: (context, index) {
                      final article = newsArticles[index];
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(
                                  255, 238, 254, 255), // لون التدرج من الأعلى
                              Color(0xFFFFF7EB), // لون التدرج من الأسفل
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        //  margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            article['urlToImage'] != null
                                ? Image.network(
                                    article['urlToImage'],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.article,
                                    size: 100), // أيقونة بديلة إذا لم توجد صورة
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                article['title'] ?? 'No Title',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                article['description'] ?? 'No Description',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (article['url'] != null) {
                                  // استخدم url_launcher لفتح الرابط
                                  // Example: launch(article['url']);
                                }
                              },
                              child: const Text(
                                "Read More",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 1.3,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
