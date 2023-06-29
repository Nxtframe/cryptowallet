import 'package:flutter/material.dart';

import '../../services/coinbaseservice.dart';

class CryptoDetails extends StatefulWidget {
  final String id;
  const CryptoDetails(
    this.id, {
    Key? key,
  }) : super(key: key);

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (result != null)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 17,
                  itemBuilder: (BuildContext ctx, index) {
                    final key = result!.keys.elementAt(index);
                    final value = result![key];
                    final formattedKey = key
                        .replaceAll("_", " ")
                        .split(" ")
                        .map(
                          (word) => word[0].toUpperCase() + word.substring(1),
                        )
                        .join(" ");

                    return Card(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      child: ListTile(
                        title: Text(
                          formattedKey,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
