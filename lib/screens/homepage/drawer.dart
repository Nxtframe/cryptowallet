import 'package:flutter/material.dart';

class EndDrawerWidget extends StatelessWidget {
  const EndDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Transaction History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Bitcoin (BTC)'),
            subtitle: const Text('Sent 0.025 BTC'),
            onTap: () {
              // Handle transaction selection
            },
          ),
          ListTile(
            title: const Text('Ethereum (ETH)'),
            subtitle: const Text('Received 1.5 ETH'),
            onTap: () {
              // Handle transaction selection
            },
          ),
          ListTile(
            title: const Text('Litecoin (LTC)'),
            subtitle: const Text('Sent 0.5 LTC'),
            onTap: () {
              // Handle transaction selection
            },
          ),
          ListTile(
            title: const Text('Ripple (XRP)'),
            subtitle: const Text('Received 1000 XRP'),
            onTap: () {
              // Handle transaction selection
            },
          ),
          ListTile(
            title: const Text('Cardano (ADA)'),
            subtitle: const Text('Received 500 ADA'),
            onTap: () {
              // Handle transaction selection
            },
          ),
          // Add more ListTiles for additional transaction history items
        ],
      ),
    );
  }
}
