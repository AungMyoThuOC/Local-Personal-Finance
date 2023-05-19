import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/splash_screen.dart';
import 'package:personal_finance/classes/language_constants.dart';
import 'package:personal_finance/provider/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _db = CreateDatabase.instance;

void main() {
  SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  // _db.deleteDB();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findRootAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void deactivate() {
    getLocale().then((locale) => {setLocale(locale)});
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);
          return MaterialApp(
            title: 'Personal Finance',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            locale: provider.locale,
          );
        },
      );
}
