import 'package:flutter/material.dart';
import 'bank_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ApexBank Secure Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.account_balance, size: 88, color: Colors.white),
            SizedBox(height: 24),
            Text('ApexBank', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Secure money transfers with ease', style: TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final BankService _bankService = BankService();
  final TextEditingController _accountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final accountNumber = _accountController.text.trim();
    final account = await _bankService.fetchAccount(accountNumber);

    if (account == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account not found. Please register or try another number.')));
      }
      return;
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BankDashboard(accountNumber: accountNumber, bankService: _bankService)));
    }
  }

  void _openRegister() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterPage(bankService: _bankService)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ApexBank Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Welcome back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Enter your account number to continue.', style: TextStyle(fontSize: 14, color: Colors.black54)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _accountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Account Number', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _openRegister,
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Register Account', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({required this.bankService, super.key});

  final BankService bankService;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final accountNumber = _accountController.text.trim();
    final name = _nameController.text.trim();
    final initialBalance = double.parse(_balanceController.text.trim());

    final result = await widget.bankService.registerAccount(accountNumber, name, initialBalance);

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(result.success ? 'Registration Completed' : 'Registration Failed'),
          content: Text(result.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (result.success) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Create a new account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _accountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Account Number', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter an account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Account Holder Name', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _balanceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Initial Balance', border: OutlineInputBorder(), prefixText: 'RM '),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter an initial balance';
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Register Account', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BankDashboard extends StatefulWidget {
  const BankDashboard({required this.accountNumber, required this.bankService, super.key});

  final String accountNumber;
  final BankService bankService;

  @override
  State<BankDashboard> createState() => _BankDashboardState();
}

class _BankDashboardState extends State<BankDashboard> {
  String _name = 'Loading...';
  double _balance = 0.0;
  final TextEditingController _toAccountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshAccountData();
  }

  Future<void> _refreshAccountData() async {
    final account = await widget.bankService.fetchAccount(widget.accountNumber);
    if (account != null) {
      setState(() {
        _name = account['accountHolderName'];
        _balance = account['balance'];
      });
    } else {
      setState(() {
        _name = 'Unknown';
        _balance = 0.0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to load account data.')));
      }
    }
  }

  Future<void> _handleTransfer() async {
    final recipient = _toAccountController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (recipient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a recipient account number.')));
      return;
    }
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount.')));
      return;
    }

    final result = await widget.bankService.transferFunds(widget.accountNumber, recipient, amount);
    if (!mounted) return;

    if (result.success) {
      _toAccountController.clear();
      _amountController.clear();
      await _refreshAccountData();
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Transaction Completed'),
            content: Text(result.message),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  void _logout() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApexBank Secure Portal'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout), tooltip: 'Logout'),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.indigo.shade800,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current account', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(widget.accountNumber, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Account Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text('Name: $_name', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Balance: RM ${_balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Transfer Money', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextField(
                  controller: _toAccountController,
                  decoration: const InputDecoration(labelText: 'To Account Number', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Amount (RM)', border: OutlineInputBorder(), prefixText: 'RM '),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleTransfer,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Authorize Transfer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
