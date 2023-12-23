// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import, use_build_context_synchronously

import 'dart:convert';

import 'package:farmshield/pages/home_page.dart';
import 'package:farmshield/pages/new_disease.dart';
import 'package:farmshield/widgets/scanning_screen.dart';
import 'package:farmshield/settings/account_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:typed_data';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/enums/dtype.dart';
import 'package:path_provider/path_provider.dart';

import '../models/result.dart';

class DiseaseDetection extends StatefulWidget {
  const DiseaseDetection({super.key});

  @override
  State<DiseaseDetection> createState() => _DiseaseDetectionState();
}

class _DiseaseDetectionState extends State<DiseaseDetection> {
  List results = [];
  bool isAns = false;
  bool imageSelected = false;
  bool isOut = false;
  var image1 = '';
  final picker = ImagePicker();

  void uploadImage() async {
    File? selectedImage = await pickImage();
    print("Working...");

    if (selectedImage != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => MyHomePage(image: selectedImage)));
    }
  }

  Future<File?> pickImage() async {
    print("Trying...");
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image1 = pickedFile.path;
        return File(pickedFile.path);
      } else {
        print('No image selected.');
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadModel();
  // }

  int pageNo = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(246, 207, 252, 230),
        body: pageNo == 0 ? const Home() : const AccountScreen(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF90EE90),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      // icon: Icon(Icons.abc),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: Text('identifydisease'.tr),
                      content: Text('Choose the method'.tr),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => pickImageFromCamera(),
                          child: Text('Take a Pic'.tr),
                        ),
                        TextButton(
                          onPressed: () => uploadImage(),
                          child: Text('Choose from Gallery'.tr),
                        ),
                      ],
                    ));
          },
          child: const Icon(
            Icons.document_scanner_outlined,
          ), //icon inside button
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          height: MediaQuery.of(context).size.height * 0.065,
          color: Color(0xFF136207),
          shape: const CircularNotchedRectangle(),
          notchMargin: 7,
          elevation: 0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    pageNo = 0;
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.people_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    pageNo = 1;
                  });

                  print(pageNo);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      image1 = pickedFile!.path;
    });
    // await classifyDisease(image);
    print(results);
  }

  Future pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      image1 = pickedFile!.path;
    });

    print('done');
    print(results);
  }
}
