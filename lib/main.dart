import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/screens/login_screen.dart';
import 'package:intechpro/screens/onboarding_screen.dart';
import 'package:intechpro/screens/register_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Color(0xff004875);
    Color _accentColor = Color(0xfff56526);
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_)=>ServiceProvider())
      ],
      child: MaterialApp(
        title: 'IntecPRO',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          primarySwatch: Colors.blue,
        ),
        home: AuthenticationWrapper(),
        routes: {
          '/onboarding': (BuildContext context) => OnboardingScreen(key: key),
          '/login': (BuildContext context) => LoginScreen(
                key: key,
              ),
          '/register': (BuildContext context) => RegisterScreen(
                key: key,
              )
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print(firebaseUser);
    if (firebaseUser != null) {
      //logined
      return HomeScreen(
       
      );
    }
    return OnboardingScreen(
      key: key,
    );
  }
}
