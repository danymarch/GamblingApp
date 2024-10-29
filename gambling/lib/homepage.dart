import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int balance = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Mostra il menu per navigare
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/lottery').then((_) {
                          _loadBalance(); // Ricarica il saldo al ritorno dalla LotteryPage
                        });
                      },
                      child: const Text('Lotteria'),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/work').then((_) {
                          _loadBalance(); // Ricarica il saldo al ritorno dalla WorkPage
                        });
                      },
                      child: const Text('Lavoro'),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.credit_card,
                size: 100,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 20),
              Text(
                'Saldo: €$balance',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
