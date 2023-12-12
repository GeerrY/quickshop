import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/requests.dart';

class EndBuyPage extends StatefulWidget {
  const EndBuyPage({super.key});

  @override
  State<EndBuyPage> createState() => _EndBuyPageState();
}

class EndBuyArguments {
  final List<Map> products;

  EndBuyArguments(this.products);
}

class _EndBuyPageState extends State<EndBuyPage> {
  bool _isLoading = true;

  String? b64Image;
  String? pixCode;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EndBuyArguments;

    if (_isLoading) {
      Future<Map> response = buyProductRequest(args.products);
      response.then((value) => {
            setState(() {
              _isLoading = false;
              b64Image = value['b64_qrcode_image'];
              pixCode = value['pix_code'];
            })
          });
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Finalizar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'assets/images/logo_quickshop.png',
                  width: 75,
                ),
              ],
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Container(
                    child: Column(
                      children: [
                        Image.memory(base64Decode(b64Image.toString().replaceAll('data:image/png;base64,', ''))),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: pixCode.toString()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.copy,
                                  color: Colors.green[800], size: 20),
                              Text(
                                'Copiar código PIX',
                                style: TextStyle(
                                    color: Colors.green[800], fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
              onPressed: () => {
                Navigator.pop(context)
              },
              child: const Text(
                'Voltar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
