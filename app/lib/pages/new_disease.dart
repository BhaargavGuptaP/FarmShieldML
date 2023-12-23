// ignore_for_file: unused_import, unused_field, prefer_const_constructors, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/enums/dtype.dart';
import 'package:path_provider/path_provider.dart';

import '../models/result.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.image});
  File? image;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAns = false;
  var finalRes;
  @override
  void initState() {
    sendImageToServer(widget.image!);
    super.initState();
  }

  List<String> idx_to_classes = [
    'Apple___Apple_scab',
    'Apple___Black_rot',
    'Apple___Cedar_apple_rust',
    'Apple___healthy',
    'Background_without_leaves',
    'Blueberry___healthy',
    'Cherry___Powdery_mildew',
    'Cherry___healthy',
    'Corn___Cercospora_leaf_spot Gray_leaf_spot',
    'Corn___Common_rust',
    'Corn___Northern_Leaf_Blight',
    'Corn___healthy',
    'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)',
    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
    'Grape___healthy',
    'Orange___Haunglongbing_(Citrus_greening)',
    'Peach___Bacterial_spot',
    'Peach___healthy',
    'Pepper,_bell___Bacterial_spot',
    'Pepper,_bell___healthy',
    'Potato___Early_blight',
    'Potato___Late_blight',
    'Potato___healthy',
    'Raspberry___healthy',
    'Soybean___healthy',
    'Squash___Powdery_mildew',
    'Strawberry___Leaf_scorch',
    'Strawberry___healthy',
    'Tomato___Bacterial_spot',
    'Tomato___Early_blight',
    'Tomato___Late_blight',
    'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot',
    'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot',
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
    'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy'
  ];

  Future<void> sendImageToServer(File imageFile) async {
    var url = Uri.parse('http://10.0.2.2:5000/detect');

    var request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();
      var respons = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        var val = jsonDecode(respons.body);
        print(val);
        finalRes = val;
        if (val == null) {
          setState(() {
            isAns = false;
          });
        } else {
          setState(() {
            isAns = true;
          });
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Example'),
      ),
      body: widget.image?.path.toString() != null
          ? Center(
              child: Column(
                children: [
                  Image.file(
                    widget.image!,
                    height: 300,
                    width: 300,
                  ),
                  finalRes != []
                      ? Column(
                          children: [
                            Text(idx_to_classes[
                                int.parse(finalRes['pred'].toString())]),
                            Text(
                              finalRes['prevent'],
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              finalRes['desc'],
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
