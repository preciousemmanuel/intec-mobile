import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/providers/artisan_request_provider.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:intechpro/providers/customer_request_provider.dart';
import 'package:intechpro/providers/customer_wallet_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/service_payment_provider.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/providers/settings_provider.dart';
import 'package:intechpro/providers/user_location_provider.dart';
import 'package:intechpro/screens/artisan/subscription_screen.dart';
import 'package:intechpro/screens/complete_artisan_profile_screen.dart';
import 'package:intechpro/screens/customer_requests_screen.dart';
import 'package:intechpro/screens/forgot_password_screen.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/screens/login_screen.dart';
import 'package:intechpro/screens/onboarding_screen.dart';
import 'package:intechpro/screens/register_screen.dart';
import 'package:intechpro/screens/registration_succes_screen.dart';
import 'package:intechpro/screens/terms_screen.dart';
import 'package:intechpro/screens/wallet_screen.dart';
import 'package:intechpro/screens/withdraw_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Color(0xff5779b9);
    Color _accentColor = Color(0xfffff6600);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => ServicePaymentProvider()),
        ChangeNotifierProvider(create: (_) => CustomerWalletProvider()),
        ChangeNotifierProvider(create: (_) => CustomerRequestProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ArtisanRequestProvider()),
        ChangeNotifierProvider(create: (_) => UserLocationProvider()),
        ChangeNotifierProvider(create: (_) => SettingProvider()),
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
              // '/register_success': (BuildContext context) => RegistrationSuccessScreen(
              //   key: key,
              // ),
              //  '/complete_profile': (BuildContext context) => CompleteProfileScreen(
              //   key: key,
              // ),
              
          '/register': (BuildContext context) => RegisterScreen(
                key: key,
              ),
               '/forgot_password': (BuildContext context) => ForgotPasswordScreen(
                key: key,
              ),
          '/wallet': (BuildContext context) => WalletScreen(),
          '/withdraw': (BuildContext context) => WithdrawScreen(),
          '/customer_requests':(BuildContext context)=>CustomerRequestsScreen(key: key,),
          '/terms_condition':(BuildContext context)=>TermsScreen(key: key,),
           '/pay_subscription':(BuildContext context)=>SubscriptionScreen(key: key,),
          // '/pay_subscription':(BuildContext context)=>SubscriptionScreen(key: key,),
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
      return HomeScreen();
    }
    return OnboardingScreen(
      key: key,
    );
  }
}
