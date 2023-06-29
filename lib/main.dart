import 'package:cryptowallet/provider/darkmodeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'screens/splash/splashscreen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DarkModeProvider>(
      create: (_) => DarkModeProvider(),
      child: Consumer<DarkModeProvider>(
        builder: (context, darkModeProvider, _) {
          return MaterialApp(
            themeMode:
                darkModeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            title: 'Flutter Demo',
            theme: ThemeData(
              // Define your light mode theme data here
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              // Define your dark mode theme data here
              brightness: Brightness.dark,
              // Customize other dark mode specific attributes
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
