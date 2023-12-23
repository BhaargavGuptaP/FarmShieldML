// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  Result({super.key, required this.image, required this.disease_name});
  File image;
  var disease_name;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.file(widget.image),
            Text('Disease Name:${widget.disease_name}'),
            Text('Disease Description'),
            Text('Disease Treatment'),
          ],
        ),
      ),
    );
  }
}
