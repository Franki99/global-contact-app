import 'package:flutter/material.dart';
import 'package:global_app/main.dart';
import '../generated/l10n.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('es', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
      ),
      body: ListView.builder(
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          Locale locale = supportedLocales[index];
          return ListTile(
            title: Text(_getLanguageName(locale)),
            onTap: () {
              _changeLanguage(context, locale);
            },
          );
        },
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'Unknown';
    }
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    MyApp.setLocale(context, locale);
  }
}
