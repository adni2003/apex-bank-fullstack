import 'package:http/http.dart' as http;
import 'dart:convert';

class ActionResult {
  final bool success;
  final String message;

  ActionResult(this.success, this.message);
}

class BankService {
  final String baseUrl = 'http://localhost:8083/api/bank';

  Future<ActionResult> registerAccount(String accountNum, String name, double initialDeposit) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/account'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, dynamic>{'accountNumber': accountNum, 'accountHolderName': name, 'balance': initialDeposit}),
      );

      if (response.statusCode == 200) {
        return ActionResult(true, 'Account successfully registered in MySQL!');
      }

      return ActionResult(false, response.body.isNotEmpty ? response.body : 'Registration failed.');
    } catch (e) {
      return ActionResult(false, 'Network error: Unable to connect to bank server.');
    }
  }

  Future<Map<String, dynamic>?> fetchAccount(String accountNum) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/account/$accountNum'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<ActionResult> transferFunds(String fromAcc, String toAcc, double amount) async {
    if (amount <= 0) return ActionResult(false, 'Amount must be greater than zero.');
    if (toAcc.trim().isEmpty) return ActionResult(false, 'Recipient account is required.');

    final Uri url = Uri.parse('$baseUrl/transfer?from=$fromAcc&to=$toAcc&amount=$amount');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return ActionResult(true, response.body.isNotEmpty ? response.body : 'Transfer completed successfully.');
      }
      return ActionResult(false, response.body.isNotEmpty ? response.body : 'Transfer failed.');
    } catch (e) {
      return ActionResult(false, 'Network error: Unable to connect to bank server.');
    }
  }
}
