import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/endbuypage.dart';
import 'package:frontend/requests.dart';
import 'package:local_auth/local_auth.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map> produtos = [];
  double totalValue = 0.0;
  final LocalAuthentication auth = LocalAuthentication();

  double calcularTotal(List<Map<dynamic, dynamic>> carrinho) {
    double total = 0.0;
    for (var item in carrinho) {
      String price = item["price"].replaceAll(r'R$ ', '').replaceAll(',', '.');
      double preco = double.parse(price);
      int quantidade = item["quant"];
      total += preco * quantidade;
    }
    return total;
  }

  Future<void> authenticateWithBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      return;
    }

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Toque o sensor de digital para finalizar a compra',

        options: const AuthenticationOptions(
          useErrorDialogs: true,
          //stickyAuth: true,
        ),
      );

      if (authenticated) {
        Navigator.pushNamed(context, '/endbuy', arguments: EndBuyArguments(produtos));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Carrinho',
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
          Container(
            height: 500,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 10,
                dataRowHeight: 60,
                columns: const [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            'Imagem',
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            'Nome',
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            'Preço',
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            'QTD',
                            textAlign: TextAlign.center,
                          ))),
                ],
                rows: produtos
                    .map(
                      (Map product) => DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              product['image'],
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            product['name'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 60,
                          child: Text(
                            product['price'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 50,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    product['quant'] -= 1;
                                    if (product['quant'] < 1) {
                                      produtos.remove(product);
                                    }
                                    totalValue = calcularTotal(produtos);
                                  });
                                },
                                child: const SizedBox(
                                  height: 30,
                                  width: 15,
                                  child: Icon(Icons.remove,
                                      color: Colors.red, size: 15),
                                ),
                              ),
                              Text(product['quant'].toString()),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      product['quant'] += 1;
                                      if (product['quant'] < 1) {
                                        produtos.remove(product);
                                      }
                                      totalValue = calcularTotal(produtos);
                                    });
                                  },
                                  child: const SizedBox(
                                    height: 30,
                                    width: 15,
                                    child: Icon(Icons.add,
                                        color: Colors.green, size: 15),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
            ),
            onPressed: () async {
              String qrCodeRes;
              try {
                qrCodeRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancelar', true, ScanMode.QR);
              } on PlatformException {
                qrCodeRes = 'Falha ao obter a versão da plataforma';
              }
              if (qrCodeRes != '-1') {
                Map product = await getProductRequest(qrCodeRes);
                setState(() {
                  produtos.add({
                    'id': product['id'],
                    'image': "http://$baseUrl${product['image']}",
                    'name': product['name'],
                    'price': product['price'],
                    'quant': 1
                  });
                  totalValue = calcularTotal(produtos);
                });
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code, color: Colors.white, size: 20),
                Text(
                  '  Adicionar item ao carrinho',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              if (produtos.length < 1) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nenhum item no carrinho.')));
              } else {
                authenticateWithBiometrics();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag, color: Colors.green[800], size: 20),
                Text(
                  r'  Finalizar compra R$ '
                  '${totalValue.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(color: Colors.green[800], fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
