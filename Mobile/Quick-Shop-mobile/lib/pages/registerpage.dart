import 'package:flutter/material.dart';
import 'package:frontend/requests.dart';
import 'package:frontend/validators.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../constants.dart';
import '../secure_storage.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
  String name = '';
  String cpf = '';
  String phone_number = '';
  String email = '';
  String password = '';
  String confirm_password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/logo_quickshop.png',
              width: 150,
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Preenha todos os campos.';
                      }
                      if (value.toString().split(' ').length < 2) {
                        return 'Digite nome e sobrenome';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nome e sobrenome',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(),
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: '###.###.###-##',
                          filter: {"#": RegExp(r'[0-9]')})
                    ],
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Preenha todos os campos.';
                      }
                      if (value.toString().length < 14) {
                        return 'CPF incompleto.';
                      }
                      if (!validarCPF(cpf)) {
                        return 'CPF inválido.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      cpf = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(),
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: '(##)#####-####',
                          filter: {"#": RegExp(r'[0-9]')})
                    ],
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Preenha todos os campos.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      phone_number = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Número de telefone',
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
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
                      if (value.toString().isEmpty) {
                        return 'Preenha todos os campos.';
                      }
                      if (value.toString().length < 6) {
                        return 'A senha precisa ter no mínimo 6 caracteres.';
                      }
                      if (value.toString() != confirm_password) {
                        return 'As senhas não coincidem.';
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
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Preenha todos os campos.';
                      }
                      if (value.toString() != password) {
                        return 'As senhas não coincidem.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      confirm_password = value;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar senha',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                  ),
                  onPressed: () async {
                    if (_loginFormKey.currentState!.validate()) {
                      Map response = await registerRequest(
                          name, cpf, phone_number, email, password);

                      if (response['success']) {
                        SecureStorage()
                            .writeSecureData('authToken', response['token']);
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(Intl.message(response['message'],
                                  name: 'mensagem'))),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'CADASTRAR',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
