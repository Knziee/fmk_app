import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/user_selection.dart';
import 'screens/home_screen/home_screen.dart';
import './services/character_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSelection()),
        Provider<CharacterService>(create: (_) => CharacterService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F Marry Kill',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
