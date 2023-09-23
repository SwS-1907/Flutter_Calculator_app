import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swscalculator/Camera.dart';
import 'package:swscalculator/Voic.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Hide the status bar and control system UI mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);


  // to set a listener in the status bar state .
  // SystemChrome.setSystemUIChangeCallback(
  //     (system0verlaysAreVisible) async {
  //  print(" CHANGED: $system0verlaysAreVisible");
  //
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String inputall = '0';
  String inputless = '0';


  Color black = Colors.black;
  Color white = Colors.white;
  Color semiblack = Colors.white10;

  String _output = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operator = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _output = '';
        _num1 = 0;
        _num2 = 0;
        _operator = '';
      }else if (buttonText == 'C'){
        String theNew = _output.substring(0,_output.length-1);
        _output = theNew ;
      } else if (buttonText == '+' || buttonText == '-' ||
          buttonText == '×' || buttonText == '÷') {
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
        if (_operator == '×') {
          _output = (_num1 * _num2).toString();
        }
        if (_operator == '÷') {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,17,16,17),
      body: Padding(
        padding: const EdgeInsets.only(left:10,right:10,top:55),
        child: Container(
          height: MediaQuery.of(context).size.height* 0.9,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255,17,16,17),
                ),
                width: double.infinity,
                height: 50,
                child: Text(inputall,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    constraints: BoxConstraints(
                      // maxWidth: constraints.maxWidth,
                    ),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255,17,16,17)
                    ),
                    width: double.infinity,
                    height: 160,
                    child: FittedBox(
                      // fit: BoxFit.scaleDown,
                      child: Text(
                        _output,
                        style:  const TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 150,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //     color: Color.fromARGB(255,17,16,17)
              //   ),
              //   width: double.infinity,
              //   height: 190,
              //   child: Text(_output,
              //     style: const TextStyle(
              //       fontWeight: FontWeight.w100,
              //       color: Colors.white,
              //       fontSize: 150,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boxed('AC'),
                  boxed('C'),
                  boxed('%'),
                  boxed('÷'),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boxed('1'),
                  boxed('2'),
                  boxed('3'),
                  boxed('×'),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boxed('4'),
                  boxed('5'),
                  boxed('6'),
                  boxed('-'),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boxed('7'),
                  boxed('8'),
                  boxed('9'),
                  boxed('+'),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boxed('0'),
                  boxed('.'),
                  boxed('='),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Color.fromARGB(255,17,16,17),
        unselectedItemColor: Colors.white38,
        selectedItemColor: const Color.fromARGB(255,254,136,1),
        onTap: (value) {
          if (value == 1){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  CameraApp(),));
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
  Widget boxed(String number){
    if (number == 'AC' || number == 'C' || number == '%' ){
      return InkWell(
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255,167,165,162)
          ),
          child: Center(
            child: Text(number,
              style: const TextStyle(
                  color:Colors.black,
                  fontSize: 60,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),
        onTap: (){
          // switch (number){
          //   case 'AC': {
          //       setState(() {
          //         inputless = '';
          //       });
          //       break;
          //     }
          //     case 'C': {
          //       setState(() {
          //         String theNew = inputless.substring(0,inputless.length-1);
          //         inputless = theNew ;
          //       });
          //       break;
          //     }
          //     // case '%': {
          //     //   setState(() {
          //     //     inputless +=
          //     //   });
          //     //   break;
          //     // }
          // }
          _buttonPressed(number);
        },
      );
    }else if (number == '÷' || number == '-' || number == '+' || number == '×' || number == '='){
      return InkWell(
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255,254,136,1)
          ),
          child: Center(
            child: Text(number,
              style: const TextStyle(
                  color:Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),
        onTap: (){
          _buttonPressed(number);
        },
      );
    }else if (number == '0'){
      return InkWell(
        child: Container(
          height: 90,
          width: 180,
          decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(10) ,
            color: Color.fromARGB(255,45,44,45)
          ),
          child: Center(
            child: Text(number,
              style: const TextStyle(
                  color:Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
        onTap: (){
          _buttonPressed(number);
        },
      );
    } else{
      return InkWell(
        onTap: (){
          _buttonPressed(number);
          // setState(() {
          //   if (inputless.isNotEmpty){
          //     if (number == '+'){
          //       int oldNbr = int.parse(inputless);
          //       inputless = (oldNbr + int.parse(number)).toString();
          //     }else if (number == '-'){
          //       int oldNbr = int.parse(inputless);
          //       inputless = (oldNbr - int.parse(number)).toString();
          //     }else if (number == '×'){
          //       int oldNbr = int.parse(inputless);
          //       inputless = (oldNbr * int.parse(number)).toString();
          //     }else if (number == '÷'){
          //       int oldNbr = int.parse(inputless);
          //       inputless = (oldNbr / int.parse(number)).toString();
          //     }
          //   }else{
          //     inputless = number;
          //   }
          // });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255,45,44,45)
          ),
          child: Center(
            child: Text(number,
              style: const TextStyle(
                  color:Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
      );
    }

  }
}