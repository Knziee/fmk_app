import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/user_selection.dart';
import 'screens/home_screen/home_screen.dart';
import './services/character_services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAxbVg_3lGCtugWkSNWal2ZZxjRnjvi4oc",
        appId: "1:412220401256:android:5223e13df75ab9d3d53ddd",
        messagingSenderId: "412220401256",
        projectId: "fmkgame-8fefa",
        databaseURL: "https://fmkgame-8fefa-default-rtdb.firebaseio.com",
        storageBucket: "fmkgame-8fefa.firebasestorage.app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
