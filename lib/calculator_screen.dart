

import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String displayText = '0';
  String expression = "";
  bool newInput = false;


  /// +, -, ×, ÷
  bool isOperator(String character){
    return character == '+' ||
    character == '-' ||
    character == '×' ||
    character == '÷';
  }

  double evaluateExpression(String expr){
    List<String> tokens = expr.split(RegExp(r'\D')).where((token) => token.isNotEmpty).toList();
    List<String> operators = expr.split(RegExp(r'(\d)')).where(
            (token)=> token.isNotEmpty && isOperator(token)).toList();

    while (operators.contains('×') || operators.contains('÷')){
      for(int i = 0; i<operators.length; i++){
        if(operators[i] == '×' || operators[i] == '÷'){
          double num1 = double.parse(tokens[i]);
          double num2 = double.parse(tokens[i+1]);
          double result;

          if(operators[i] == '×'){
            result = num1 * num2;
          }else {
            result = num1 / num2;
          }

          tokens.removeAt(i);
          tokens[i] = result.toString();
          operators.removeAt(i);
          break;


        }
      }
    }
    double result = double.parse(tokens[0]);
    for(int i = 0; i<operators.length; i++){
      double nextNumber = double.parse(tokens[i+1]);
      if(operators[i] == '+'){
        result += nextNumber;
      }else if(operators[i] == '-'){
        result -= nextNumber;
      }
    }

    return result;

  }

  void buttonPressed(String buttonText){
    setState(() {
      if(buttonText == 'C'){
        displayText = '0';
        expression = '';
        newInput = false;

      }else if(buttonText == '='){
        try{
          displayText = evaluateExpression(expression).toString();
          expression = displayText;
          newInput = true;
        }catch(e){
          displayText = 'Error';
          newInput = true;
        }
      }else {
        if(newInput){
          expression = buttonText;
          displayText = expression;
          newInput = false;
        }
        else {
          if(expression == '0') expression = '';

          // Prevent multiple operators
          if(isOperator(buttonText) && expression.isNotEmpty
              && isOperator(expression[expression.length-1])){
            expression = expression.substring(0, expression.length - 1) + buttonText;
          }else {
            expression += buttonText;
          }
          displayText = expression;
        }
      }



    });
  }

  Widget buildButton(String buttonText, {Color? color, Color? textColor}){
    return Expanded(
        child:  Padding(padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            backgroundColor: color ?? Colors.grey[850],
          ),
            onPressed: () => buttonPressed(buttonText), child: Text(buttonText,
        style: TextStyle(
          fontSize: 24,
         color:  textColor ?? Colors.white,
          fontWeight: FontWeight.bold,
        ),
        ),
        ),

        ),);
  }

  /// +, -, ×, ÷
Widget  buildButtonGrid(){
    const List<List<String>> buttonConfig = <List<String>>[
      ['7','8','9','÷'],
      ['4','5','6','×'],
      ['1','2','3','-'],
      ['C','0','=','+'],
    ];
    const buttonColors = [null, null, null, Colors.orange];
    return Column(
      children: buttonConfig.map((row){
        return Row(
          children: row.map((buttonText){
            int index = row.indexOf(buttonText);
            return buildButton(buttonText,
            color:  buttonColors[index],
              textColor:  buttonText == 'C' ?
                  Colors.red[600] : buttonText == '='

                ? Colors.green[700] : Colors.white,
            );
          }).toList()
        );
      }).toList()
    );


  }

  /// Thanks for watching. Please subscribe for more related videos.



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Calculator',
        style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(displayText,
            style: const TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.w300
            ),
            ),
          ),
          const Divider(color: Colors.grey,),
          buildButtonGrid(),
        ],
      ),
    );
  }
}