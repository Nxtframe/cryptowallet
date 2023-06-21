import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';

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

  EnhancedHttp currencies = EnhancedHttp(
    baseURL: "https://api.swapzone.io/v1",
    headers: {'x-api-key': 'dOrEBHNCU'},
  );

  Future<void> apiCall() async {
    final response = await currencies.get("/exchange/currencies");
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
        children: [
          Expanded(
            child: SizedBox(
              height: height * 1 / 3,
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: selectedCrypto,
                          hint: const Text("Cryptocurrency"),
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
                        Expanded(
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
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: result?.length ?? 0, // Perform null check
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text(result?[index]["name"].toString() ?? ""),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
