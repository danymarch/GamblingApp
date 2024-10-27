import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SlotMachine());
}

class SlotMachine extends StatelessWidget {
  const SlotMachine({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int balance = 100;
  final Random random = Random();
  String resultMessage = "";
  Color resultColor = Colors.black;
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _objectiveController = TextEditingController();
  int? objective;

  void play() {
    if (balance <= 0) {
      showLossDialog();
      return;
    }

    if (_goalController.text.isEmpty) {
      _showSnackBar('Inserisci l’importo da scommettere.');
      return;
    }

    int goal;
    try {
      goal = int.parse(_goalController.text);
    } catch (e) {
      _showSnackBar('Inserisci un numero valido.');
      return;
    }

    if (goal > balance) {
      _showSnackBar('L’importo della scommessa non può superare il saldo disponibile.');
      return;
    }

    int numero = random.nextInt(2);
    if (numero == 1) {
      int goall = goal*2;
      balance += goall;
      resultMessage = "Hai vinto €$goall!";
      resultColor = Colors.green;
    } else {
      balance -= goal;
      resultMessage = "Hai perso €$goal.";
      resultColor = Colors.red;
    }

    if (objective != null && balance >= objective!) {
      _showWinDialog();
    }

    setState(() {});
    _goalController.clear();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showObjectiveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Imposta il tuo obiettivo'),
          content: TextField(
            controller: _objectiveController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Saldo obiettivo',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Imposta obiettivo'),
              onPressed: () {
                if (_objectiveController.text.isEmpty) {
                  _showSnackBar('Inserisci un obiettivo valido.');
                  return;
                }
                objective = int.tryParse(_objectiveController.text);
                if (objective == null || objective! <= 0) {
                  _showSnackBar('Inserisci un numero valido.');
                  return;
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showLossDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hai perso!'),
          content: const Text('Il tuo saldo è sceso a 0.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hai vinto!'),
          content: Text('Hai raggiunto il tuo obiettivo di €$objective!'),
          actions: [
            TextButton(
              child: const Text('Riavvia'),
              onPressed: () {
                Navigator.of(context).pop();
                _reset();
              },
            ),
            TextButton(
              child: const Text('Continua senza obiettivo'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  objective = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _reset() {
    setState(() {
      balance = 100;
      objective = null;
      resultMessage = "";
      resultColor = Colors.black;
      _goalController.clear();
      _objectiveController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gambling'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showObjectiveDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Saldo: €$balance',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              resultMessage,
              style: TextStyle(fontSize: 20, color: resultColor),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Importo da scommettere',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: play,
              child: const Text('Gioca'),
            ),
            const SizedBox(height: 10),
            if (objective != null)
              Text(
                'Obiettivo: €$objective',
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }
}