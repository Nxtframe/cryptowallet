import 'package:cryptowallet/screens/cryptodetail/cryptodetail.dart';
import 'package:flutter/material.dart';

import '../../services/coinbaseservice.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _formkey = GlobalKey<FormFieldState>();
  List<dynamic>? result; // Initialize with null

  String? selectedCrypto;
  final TextEditingController _tosend = TextEditingController();
  final TextEditingController _toreceive = TextEditingController();

  Future<void> apiCall() async {
    final cb = CoinbaseService();
    cb.initialize();
    final response = await cb.getCurrencies();

    print(await cb.getConversionRate("BTC", "USD"));

    if (mounted) {
      setState(() {
        result = response;
      });
    }
  }

  void setCrypto(String? crypto) {
    setState(() {
      selectedCrypto = crypto!;
    });
  }

  void _redirectToDetails() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const CryptoDetails())));
  }

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: height * 1 / 3,
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                          child: DropdownButton<String>(
                            value: selectedCrypto,
                            hint: const Text(
                              "Cryptocurrency",
                              overflow: TextOverflow.fade,
                            ),
                            items: result?.map<DropdownMenuItem<String>>(
                                    (dynamic currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency['name'].toString(),
                                    child: Text(currency['name'].toString()),
                                  );
                                }).toList() ??
                                [], // Perform null check and provide empty list
                            onChanged: setCrypto,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            controller: _tosend,
                            decoration: const InputDecoration(
                              hintText: "Amount of Crypto to send",
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _toreceive,
                      decoration: const InputDecoration(
                        hintText: "Amount of Crypto user will receive",
                      ),
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('Send'))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: result?.length ?? 0, // Perform null check
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: _redirectToDetails,
                  leading: Text(result?[index]["name"].toString() ?? ""),
                  title: Text(
                    result?[index]["id"].toString() ?? "",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
