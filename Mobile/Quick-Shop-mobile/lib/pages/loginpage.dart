import 'package:flutter/material.dart';
import 'package:frontend/requests.dart';
import 'package:frontend/secure_storage.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/images/logo_quickshop.png',
            width: 150,
            height: 150,
          ),
          Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'Preenha todos os campos.';
                  }
                  final bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value.toString());
                  if (!emailValid) {
                    return 'Digite um email valido.';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'Preencha todos os campos.';
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
              ),
            ],
          ),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
              ),
              onPressed: () async {
                if (_loginFormKey.currentState!.validate()) {
                  Map response = await loginRequest(email, password);
                  if (response['success']) {
                    SecureStorage()
                        .writeSecureData('authToken', response['token']);
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  } else {
                    print(response);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(Intl.message(response['message'],
                              name: 'mensagem'))),
                    );
                  }
                }
              },
              child: const Text(
                'ENTRAR',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
          )
        ],
      ),
    );
  }
}
