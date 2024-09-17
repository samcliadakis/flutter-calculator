import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // Ensure this package is added in pubspec.yaml

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sam Cliadakis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0'; // Display for the current calculation
  String _expression = ''; // Expression in progress

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _display = '0';
      } else if (buttonText == '=') {
        try {
          final result = _evaluateExpression(_expression);
          _display = '$_expression = $result';
          _expression = ''; // Clear expression after evaluation
        } catch (e) {
          _display = 'Error';
          _expression = ''; // Clear expression after error
        }
      } else if (buttonText == '^2') {
        if (_expression.isNotEmpty) {
          try {
            final result = _evaluateExpression(_expression);
            _expression = '$result^2';
            _display = _expression;
          } catch (e) {
            _display = 'Error';
            _expression = ''; // Clear expression after error
          }
        }
      } else {
        if (_display == 'Error') {
          _expression = buttonText;
          _display = buttonText;
        } else {
          // Append new button text to expression
          if (_expression.isEmpty && buttonText == '-') {
            _expression = buttonText;
            _display = buttonText;
          } else {
            _expression += buttonText;
            _display = _expression;
          }
        }
      }
    });
  }

  double _evaluateExpression(String expression) {
    try {
      // Convert to valid operators
      expression = expression.replaceAll('x', '*').replaceAll('÷', '/').replaceAll('^2', '**2');

      // Use the expressions package to evaluate the expression
      final parsedExpression = Expression.parse(expression);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(parsedExpression, {});

      return result.toDouble();
    } catch (e) {
      throw Exception('Error in expression');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              alignment: Alignment.bottomRight,
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('÷'),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('x'),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-'),
                ],
              ),
              Row(
                children: [
                  _buildButton('0'),
                  _buildButton('C'),
                  _buildButton('='),
                  _buildButton('+'),
                ],
              ),
              Row(
                children: [
                  _buildButton('^2'), // Add the square button here
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, padding: const EdgeInsets.all(24), backgroundColor: Colors.blue,
          minimumSize: const Size(0, 80), // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}