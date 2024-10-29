import 'package:flutter/material.dart';
import 'dart:math';
import 'DatabaseHelper.dart';

class LotteryPage extends StatefulWidget {
  const LotteryPage({super.key});

  @override
  State<LotteryPage> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {
  int balance = 1500; // Aggiornato per riflettere il bilancio iniziale
  final Random random = Random();
  String resultMessage = "";
  Color resultColor = Colors.black;
  final TextEditingController _betController = TextEditingController();
  
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    balance = await dbHelper.getBalance();
    setState(() {});
  }

  void playLottery() async {
    if (balance <= 0) {
      showLossDialog();
      return;
    }

    if (_betController.text.isEmpty) {
      _showSnackBar('Inserisci l’importo da scommettere.');
      return;
    }

    int bet;
    try {
      bet = int.parse(_betController.text);
    } catch (e) {
      _showSnackBar('Inserisci un numero valido.');
      return;
    }

    if (bet > balance) {
      _showSnackBar('L’importo della scommessa non può superare il saldo disponibile.');
      return;
    }

    int numero = random.nextInt(2);
    if (numero == 1) {
      int winnings = bet * 2; // Modificato per mantenere la vincita
      balance += winnings;
      await dbHelper.updateBalance(balance);
      resultMessage = "Hai vinto €$winnings!";
      resultColor = Colors.green;
    } else {
      balance -= bet;
      await dbHelper.updateBalance(balance);
      resultMessage = "Hai perso €$bet.";
      resultColor = Colors.red;
    }

    setState(() {});
    _betController.clear();
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
                _reset();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _reset() async {
    balance = 1500; // Reimposta il saldo
    await dbHelper.updateBalance(balance);
    setState(() {
      resultMessage = "";
      resultColor = Colors.black;
      _betController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lottery'),
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
              controller: _betController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Importo da scommettere',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: playLottery,
              child: const Text('Gioca alla Lotteria'),
            ),
          ],
        ),
      ),
    );
  }
}
