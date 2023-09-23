import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:swscalculator/Camera.dart';
import 'package:swscalculator/main.dart';

class VoiceApp extends StatefulWidget {
  const VoiceApp({super.key});

  @override
  State<VoiceApp> createState() => _VoiceAppState();
}

class _VoiceAppState extends State<VoiceApp> {
  SpeechToText speech = SpeechToText();
  bool animListener = false ;
  String textRecog = 'Hold the voice button to start recording.';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255,17,16,17),
        title: const Text('Voice Operation Recognized .'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 100,
        animate: animListener ,
        repeat: true,
        showTwoGlows: true,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.black,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!animListener){
              var start = await speech.initialize();
              if (start){
                setState(() {
                  animListener = true ;
                  speech.listen(
                    onResult: (result) {
                      if (result.recognizedWords.isEmpty){
                        setState(() {
                          textRecog = "" ;
                        });
                      }else{
                        setState(() {
                          RegExp regex = RegExp(r'[a-zA-Z]');
                          var text = result.recognizedWords;
                          bool hasAlphabet = regex.hasMatch(text);
                          if (!hasAlphabet) {
                            Parser parser = Parser();
                            Expression expression = parser.parse(text);
                            ContextModel contextModel = ContextModel();
                            var result = expression.evaluate(EvaluationType.REAL, contextModel);
                            textRecog = '$text = $result';
                          }else{
                            textRecog = result.recognizedWords ;
                          }
                        });
                      }
                    },
                  );
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              animListener = false ;
            });
          },
          child:  CircleAvatar(
            backgroundColor: animListener ? Colors.black12 :const Color.fromARGB(255,17,16,17),
            foregroundColor: Colors.white,
            radius: 35,
            child: const Icon(Icons.mic,size: 35,),
          ),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.only(left:10,right:10),
        child: Center(
          child: Text(textRecog,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: const Color.fromARGB(255,17,16,17),
        unselectedItemColor: Colors.white38,
        selectedItemColor: const Color.fromARGB(255,254,136,1),
        onTap: (value) {
          if (value  == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));
          }else if (value == 1){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  CameraApp(),));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Edit'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_voice),
              label: 'Edit'
          ),
        ],
      ),
    );
  }
}
