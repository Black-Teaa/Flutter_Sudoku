import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';  

class SudokuScreen extends StatefulWidget {
  @override
  _SudokuScreenState createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  late Sudoku _sudoku;  
  List<int> _currentPuzzle = List.filled(81, -1); 
  List<int> _userInput = List.filled(81, -1); 

  @override
  void initState() {
    super.initState();
    _initializeSudoku();  
  }

  void _initializeSudoku() {
    _sudoku = Sudoku.generate(Level.easy);  
    setState(() {
      _currentPuzzle = List.from(_sudoku.puzzle);  
    });
  }

  void _onCellChanged(int index, String value) {
    setState(() {
      
      int parsedValue = int.tryParse(value) ?? -1;
      if (_sudoku.puzzle[index] == -1) { 
        _userInput[index] = parsedValue;
      }
    });
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cellSize = constraints.maxWidth * 0.5 / 9;  

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9, 
            crossAxisSpacing: 0.5, 
            mainAxisSpacing: 0.5, 
          ),
          itemCount: 81, 
          itemBuilder: (context, index) {
            int value = _currentPuzzle[index];

            return _buildCell(index, value, cellSize); 
          },
        );
      },
    );
  }

Widget _buildCell(int index, int value, double cellSize) {

  bool isLastRow = Matrix.getRow(index) == 8; 
  bool isLastCol = Matrix.getCol(index) == 8;  
  bool isInBlock = Matrix.getRow(index) % 3 == 0 || Matrix.getCol(index) % 3 == 0;
  
 
  bool isEmptyCell = value == -1;
 
  bool isFilledCell = !isEmptyCell && value != -1;

  return Container(
    width: cellSize,
    height: cellSize,
    decoration: BoxDecoration(     
      color: isEmptyCell 
          ? const Color.fromARGB(255, 179, 232, 119)  
          : isFilledCell
              ? const Color.fromARGB(255, 140, 210, 242) 
              : Colors.transparent,   
      border: Border(
        top: BorderSide(
          color: (Matrix.getRow(index) % 3 == 0) ? Colors.black : Colors.transparent,
          width: 1.0,  
        ),
        left: BorderSide(
          color: (Matrix.getCol(index) % 3 == 0) ? Colors.black : Colors.transparent,
          width: 1.0, 
        ),
        
        right: BorderSide(
          color: isLastCol ? Colors.black : Colors.transparent, 
          width: 1.0,
        ),
        bottom: BorderSide(
          color: isLastRow ? Colors.black : Colors.transparent,  
          width: 1.0,
        ),
      ),
    ),
    child: value != -1
        ? Center(
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: cellSize * 0.9, fontWeight: FontWeight.bold),  
            ),
          )
        : _userInput[index] != -1
            ? Center(
                child: Text(
                  _userInput[index].toString(),
                  style: TextStyle(fontSize: cellSize * 0.9),
                ),
              )
            : GestureDetector(
                onTap: () {
                  _showInputDialog(index, cellSize);
                },
                child: Container(
                  color: Colors.transparent, 
                ),
              ),
  );
}

  void _showInputDialog(int index, double cellSize) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите число'),
          content: Container(
            width: cellSize * 0.7,  
            height: cellSize * 4,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: 1,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _onCellChanged(index, value);
                  Navigator.pop(context);
                }
              },
              decoration: InputDecoration(
                counterText: "",
                hintText: "Введите число",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        );
      },
    );
  }
 
  bool _isPuzzleCorrect() {
    for (int i = 0; i < 81; i++) {
      if (_userInput[i] != -1 && _userInput[i] != _sudoku.solution[i]) {
        return false;  
      }
    }
    return true; 
  }


  void _giveHint() {
    setState(() {
      
      for (int i = 0; i < 81; i++) {
        if (_userInput[i] == -1 && _sudoku.puzzle[i] == -1) {
          _userInput[i] = _sudoku.solution[i];
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
          
            Container(
              height: MediaQuery.of(context).size.height * 0.5,  
              width: MediaQuery.of(context).size.width * 0.5, 
              child: _buildGrid(),  
            ),
           
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),  
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,  
                children: [
                  ElevatedButton(
                    onPressed: _isPuzzleCorrect() ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Поздравляю, вы решили судоку!'))
                      );
                    } : null,
                    child: Text('Проверить решение'),
                  ),
                  SizedBox(width: 8), 
                  ElevatedButton(
                    onPressed: _giveHint,
                    child: Text('Подсказка'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
