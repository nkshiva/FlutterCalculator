import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  String _expression = '';

  void _appendText(String text) {
    setState(() {
      _expression += text;
      _controller.text = _expression;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _controller.clear();
    });
  }

  void _calculate() {
    try {
      final result = _evaluateExpression(_expression);
      setState(() {
        _expression = result.toString();
        _controller.text = _expression;
      });
    } catch (e) {
      setState(() {
        _expression = '';
        _controller.text = _expression;
      });
    }
  }

  double _evaluateExpression(String expression) {
    Parser p = Parser();
    Expression exp = p.parse(expression.replaceAll('x', '*').replaceAll('÷', '/'));
    ContextModel cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // Set background color to black
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: _controller,
                    readOnly: true,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 40, color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.black, // Light black background for the container
                  padding: EdgeInsets.all(14),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columns for buttons
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.5, // Rectangle buttons
                    ),
                    itemCount: 18, // Adjusted item count
                    itemBuilder: (context, index) {
                      final List<String> labels = [
                        '1', '2', '3',
                        '4', '5', '6',
                        '7', '8', '9',
                        '0', '+', '-',
                        '*', '/', '%',
                        '.','C', '=' // Cancel and Equals
                      ];

                      final List<Color> buttonColors = [
                        Colors.grey, Colors.grey, Colors.grey,
                        Colors.grey, Colors.grey, Colors.grey,
                        Colors.grey, Colors.grey, Colors.grey,
                        Colors.grey, Colors.yellow, Colors.yellow,
                        Colors.yellow, Colors.yellow, Colors.yellow,
                        Colors.yellow,Colors.red, Colors.green,
                      ];

                  
                      if (index == 16 || index == 17) {
                        return Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColors[index],
                              padding: EdgeInsets.symmetric(vertical: 20),
                            ),
                            onPressed: () {
                              if (index == 16) {
                                _clear(); // 'C' button clears the input
                              } else {
                                _calculate(); // '=' button calculates the result
                              }
                            },
                            child: Text(
                              labels[index],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }

                      return _buildButton(labels[index], buttonColors[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(16),
      ),
      onPressed: () => _appendText(label),
      child: Text(label, style: TextStyle(fontSize: 19)),
    );
  }
}
