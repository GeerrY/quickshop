import 'package:flutter/material.dart';
import 'package:frontend/secure_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Perfil',
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
          ElevatedButton(
            onPressed: () => {
              SecureStorage().deleteSecureData('authToken'),
              Navigator.pushNamedAndRemoveUntil(
                  context, '/index', (route) => false)
            },
            child: const Text(
              'Sair',
              style: TextStyle(
                  color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
