import 'package:flutter/material.dart';

import '../../services/coinbaseservice.dart';

class CryptoDetails extends StatefulWidget {
  final String id;
  const CryptoDetails(
    this.id, {
    super.key,
  });

  @override
  State<CryptoDetails> createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {
  Map<String, dynamic>? result;

  Future<void> apiCall() async {
    final cb = CoinbaseService();
    await cb.initialize();

    final response = await cb.getConversionRate(widget.id, "USD");

    if (mounted) {
      setState(() {
        result = response;
      });
    }
    print(result);
  }

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            if (result != null)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: 17,
                  itemBuilder: (BuildContext ctx, index) {
                    final key = result!.keys.elementAt(index);
                    final value = result![key];
                    final formattedKey = key
                        .replaceAll("_", " ")
                        .split(" ")
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(" ");

                    return ListTile(
                      subtitle: Text(formattedKey),
                      title: Text(value.toString()),
                    );
                  },
                ),
              ),
            if (result == null)
              const CircularProgressIndicator(), // Display a loading indicator
          ],
        ),
      ),
    );
  }
}
