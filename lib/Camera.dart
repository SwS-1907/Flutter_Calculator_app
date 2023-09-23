import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:swscalculator/Voic.dart';
import 'package:swscalculator/main.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("Text Recognition example"),
      // ),
      backgroundColor: const Color.fromARGB(255,17,16,17),
      body: Center(
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (textScanning) const CircularProgressIndicator(),
                    if (!textScanning && imageFile == null)
                      Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[300]!,
                      ),
                    if (imageFile != null) Image.file(File(imageFile!.path)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              backgroundColor: Colors.white,
                              shadowColor: Colors.grey[400],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.grey,
                                shadowColor: Colors.grey[400],
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              onPressed: () {
                                getImage(ImageSource.camera);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons .camera_alt,
                                      size: 30,
                                    ),
                                    Text(
                                      "Camera",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SelectableText(
                      scannedText,
                      style: const TextStyle(fontSize: 20,color: Colors.white),
                    )
                  ],
                )
            ),
          )
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Color.fromARGB(255,17,16,17),
        unselectedItemColor: Colors.white38,
        selectedItemColor: const Color.fromARGB(255,254,136,1),
        onTap: (value) {
          if (value  == 0){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));
          }else if (value == 2){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VoiceApp(),));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_voice),
              label: 'Edit'
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
        RegExp regex = RegExp(r'[a-zA-Z]');
        bool hasAlphabet = regex.hasMatch(scannedText);
        if (!hasAlphabet) {
          Parser parser = Parser();
          Expression expression = parser.parse(scannedText);
          ContextModel contextModel = ContextModel();
          var result = expression.evaluate(EvaluationType.REAL, contextModel);
          scannedText += ' = $result';
        }
      }
    }
    textScanning = false;
    setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

}






/*
 String _output = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operator = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '';
        _num1 = 0;
        _num2 = 0;
        _operator = '';
      } else if (buttonText == '+' || buttonText == '-' ||
          buttonText == '*' || buttonText == '/') {
        _operator = buttonText;
        _num1 = double.parse(_output);
        _output = '';
      } else if (buttonText == '=') {
        _num2 = double.parse(_output);
        if (_operator == '+') {
          _output = (_num1 + _num2).toString();
        }
        if (_operator == '-') {
          _output = (_num1 - _num2).toString();
        }
        if (_operator == '*') {
          _output = (_num1 * _num2).toString();
        }
        if (_operator == '/') {
          _output = (_num1 / _num2).toString();
        }
        _num1 = 0;
        _num2 = 0;
        _operator = '';
      } else {
        _output += buttonText;
      }
    });
  }

  Widget _buildButton(String buttonText, Color buttonColor, Color textColor) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _buttonPressed(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(buttonColor),
          foregroundColor: MaterialStatePropertyAll<Color>(textColor),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
            child: Text(
              _output,
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            children: <Widget>[
              _buildButton('7', Colors.grey[300]!, Colors.black),
              _buildButton('8', Colors.grey[300]!, Colors.black),
              _buildButton('9', Colors.grey[300]!, Colors.black),
              _buildButton('/', Colors.orange, Colors.white),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('4', Colors.grey[300]!, Colors.black),
              _buildButton('5', Colors.grey[300]!, Colors.black),
              _buildButton('6', Colors.grey[300]!, Colors.black),
              _buildButton('*', Colors.orange, Colors.white),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('1', Colors.grey[300]!, Colors.black),
              _buildButton('2', Colors.grey[300]!, Colors.black),
              _buildButton('3', Colors.grey[300]!, Colors.black),
              _buildButton('-', Colors.orange, Colors.white),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('0', Colors.grey[300]!, Colors.black),
              _buildButton('C', Colors.grey[300]!, Colors.black),
              _buildButton('=', Colors.orange, Colors.white),
              _buildButton('+', Colors.orange, Colors.white),
            ],
          ),
        ],
      ),
    );
  }
 */