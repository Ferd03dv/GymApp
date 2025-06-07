import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymfit/Admin/CreateAccount.dart';
import 'package:gymfit/DAO/MongoDB.dart';
import 'Pagine/ChiSiamo.dart';
import 'Pagine/Contatti.dart';
import 'Pagine/Download.dart';
import 'Pagine/Privacy.dart';
import 'Pagine/Segnalazioni.dart';
import 'Providers/AuthProvider.dart';
import 'Providers/CorsoProvider.dart';
import 'Providers/ExerciseProvider.dart';
import 'Providers/SchedeProvider.dart';
import 'Providers/SelectedExerciseProvider.dart';
import 'Providers/UsersProvider.dart';
import 'package:provider/provider.dart';
import 'Accesso/SignIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await Mongodb.connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SchedeProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => SelectedExercisesProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CorsoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GymFitApp',
        initialRoute: '/sign_in',
        theme: ThemeData(
          primaryColor: Colors.black, // Colore primario rosso
          colorScheme: ColorScheme.fromSwatch(
                  // Imposta il rosso come colore principale
                  )
              .copyWith(
            primary: Colors.black, // Colore primario per i widget
            secondary: Colors.black, // Colore secondario
            onPrimary: Colors.white, // Colore del testo su sfondi rossi
            onSecondary: Colors.white, // Colore del testo su sfondi neri
            surface:
                Colors.white, // Colore delle superfici (es. fondo dei dialoghi)
            error: Colors.black, // Colore per gli errori
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black, // Colore della barra app
            titleTextStyle: TextStyle(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black, // Colore del cursore
            selectionColor: Colors.black, // Colore del testo selezionato
            selectionHandleColor:
                Colors.black, // Colore della maniglia di selezione
          ),
          checkboxTheme: const CheckboxThemeData(
              shape: CircleBorder(),
              fillColor: WidgetStatePropertyAll(Colors.white),
              checkColor: WidgetStatePropertyAll(Colors.black)),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(color: Colors.black),
              backgroundColor: Colors.black, // Colore del pulsante
              foregroundColor: Colors.black, // Colore del testo
            ),
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white, // Colore di sfondo dei dialoghi
            titleTextStyle: TextStyle(color: Colors.black),
            contentTextStyle: TextStyle(color: Colors.black),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            hintStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        routes: {
          '/sign_in': (context) => const SignInWidget(),
          '/create_account': (context) =>
              const CreaAccountWidget(isAdmin: false),
          '/ChiSiamo': (context) => const ChiSiamo(),
          '/Segnalazioni': (context) => const Segnalazioni(),
          '/Contatti': (context) => const Contatti(),
          '/Download': (context) => const Download(),
          '/Privacy': (context) => const Privacy(),
        },
      ),
    );
  }
}
