import 'package:cryptowallet/screens/cryptodetail/cryptodetail.dart';
import 'package:cryptowallet/screens/homepage/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/darkmodeprovider.dart';
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
  bool isDarkMode = false;
  Future<void> apiCall() async {
    final cb = CoinbaseService();
    await cb.initialize();
    final response = await cb.getCurrencies();

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

  void _redirectToDetails(String id) {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => CryptoDetails(id))));
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
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Switch(
          value: darkModeProvider.isDarkMode,
          onChanged: (value) {
            darkModeProvider.setDarkMode(value);
          },
        ),
      ),
      endDrawer: const EndDrawerWidget(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: height * 1 / 3,
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Colors.redAccent,
                                Colors.blueAccent,
                                Colors.purpleAccent
                              ]),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.57),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
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
                                          child:
                                              Text(currency['name'].toString()),
                                        );
                                      },
                                    ).toList() ??
                                    [],
                                onChanged: setCrypto,
                              ),
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
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: result?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final currencyName = result?[index]["name"].toString() ?? "";
                final currencyId = result?[index]["id"].toString() ?? "";
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: darkModeProvider.isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    onTap: () => _redirectToDetails(currencyId),
                    leading: Text(
                      currencyName,
                      style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      currencyId,
                      style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
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
