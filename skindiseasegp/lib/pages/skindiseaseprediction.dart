import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'history.dart';

class SkinDiseasePrediction extends StatefulWidget {
  const SkinDiseasePrediction({super.key});
  static String id = 'SkinDiseasePrediction'; // Route name

  @override
  _SkinDiseasePredictionState createState() => _SkinDiseasePredictionState();
}

class _SkinDiseasePredictionState extends State<SkinDiseasePrediction> {
  File? _image;
  final picker = ImagePicker();
  String? _prediction;
  double? _confidence;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // Reset prediction and confidence when a new image is picked
        _prediction = null;
        _confidence = null;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final url = Uri.parse('http://10.0.2.2:5000/predict');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var result = json.decode(responseData);

      setState(() {
        _prediction = result['class'];
        _confidence = result['confidence'];
      });

      // Save prediction to Firebase
      _savePredictionToFirebase(_prediction!, _confidence!);
    } else {
      print('Failed to upload image.');
    }
  }

  Future<void> _savePredictionToFirebase(
      String prediction, double confidence) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _image != null) {
      // Convert image to Base64
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('predictions')
          .add({
        'prediction': prediction,
        'confidence': confidence,
        'image': base64Image, // Save image as Base64 string
        'timestamp': DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            'Detector',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, size: 50, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null
                  ? const Text(
                      'No image selected.',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 199, 229, 254),
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        _image!,
                        // height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(height: 30),
              _prediction == null
                  ? const Text(
                      'No prediction yet.',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  : Text(
                      'Prediction: $_prediction\nConfidence: ${(_confidence! * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text(
                  'Upload Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text(
                  'Predict',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
