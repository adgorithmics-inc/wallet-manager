import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:wallet_manager/wallet_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Manager Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const CreateWalletPage(),
    );
  }
}

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({Key? key}) : super(key: key);

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  late WalletManager _manager;
  WalletKeys? _walletKeys;

  @override
  void initState() {
    _manager = WalletManager();
    super.initState();
  }

  _generateWallet() async {
    _walletKeys = await _manager.createWallet();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wallet'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RestoreWalletPage())),
        tooltip: 'Restore wallet',
        child: const Icon(Icons.restore),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your public key / wallet address'),
            Text(_walletKeys?.publicKey ?? ''),
            const SizedBox(height: 16.0),
            const Text('Your private key'),
            InkWell(
              onTap: () {
                FlutterClipboard.copy(_walletKeys?.privateKey ?? '').then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Private key copied!'),
                      ),
                    );
                  },
                );
              },
              child: Text(_walletKeys?.privateKey ?? ''),
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: _generateWallet,
              child: Container(
                width: double.infinity,
                height: 44.0,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  'Generate new Wallet',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestoreWalletPage extends StatefulWidget {
  const RestoreWalletPage({Key? key}) : super(key: key);

  @override
  State<RestoreWalletPage> createState() => _RestoreWalletPageState();
}

class _RestoreWalletPageState extends State<RestoreWalletPage> {
  TextEditingController controller = TextEditingController();
  String? walletAddress;
  late WalletManager manager;

  @override
  void initState() {
    manager = WalletManager();
    super.initState();
  }

  void _restoreWallet() async {
    walletAddress = await manager.restoreWallet(controller.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore Wallet'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'insert your private key',
                ),
              ),
              const SizedBox(height: 16.0),
              Text(walletAddress ?? ''),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: _restoreWallet,
                child: Container(
                  width: double.infinity,
                  height: 44.0,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    'Generate new Wallet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
