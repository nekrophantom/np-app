import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:np_app/pages/home_page.dart';
import 'package:np_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';

Future<void> main() async {
  
  if(kReleaseMode){
    await dotenv.load(
      fileName: '.env.production',
    );
  }else{
    await dotenv.load(
      fileName: '.env.development',
    );
  }

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider()
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: auth.isAuth ? HomePage() :
           LoginPage(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.deepPurple[800],
              secondary: Colors.deepPurple[600]
            )
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}