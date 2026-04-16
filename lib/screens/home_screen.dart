import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  Uint8List? _enhancedImage;
  bool _loading = false;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future enhanceImage() async {
    if (_image == null) return;

    setState(() => _loading = true);

    final result = await AiService.enhanceImage(_image!);

    setState(() {
      _enhancedImage = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Photo Enhancer")),
      body: Column(
        children: [
          if (_image != null) Image.file(_image!),
          if (_enhancedImage != null) Image.memory(_enhancedImage!),

          if (_loading) CircularProgressIndicator(),

          ElevatedButton(onPressed: pickImage, child: Text("Pick Image")),
          ElevatedButton(onPressed: enhanceImage, child: Text("Enhance Image")),
        ],
      ),
    );
  }
}