import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immonot/models/language/language_model.dart';
import 'package:interpolation/interpolation.dart';

/// AppLocalizations fetches the translations strings from json files located in assets/lang
/// and provides them to UI widgets with AppLocalizations.of(context).translate('key', [params])
///
class AppLocalizations {
  final Interpolation interpolation = Interpolation();

  // localization variables
  final Locale locale;
  Map<String, String> localizedStrings;

  // List of supported languages
  static List<Language> supportedLanguages = const [
    Language(code: 'US', locale: 'en', language: 'English'),
    Language(code: 'FR', locale: 'fr', language: 'Français'),
  ];

  static List<Locale> supportedLocales() {
    return supportedLanguages.map((language) => Locale(language.locale, language.code)).toList();
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // constructor
  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(final BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // This is a helper method that will load local specific strings from file
  // present in lang folder
  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    final String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;

    localizedStrings = jsonMap.map((String key, value) {
      return MapEntry(key, value.toString().replaceAll(r"\'", "'").replaceAll(r'\t', ' '));
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  // Data passed through the optional "params" map will be interpolated with {key} in the localized string
  String translate(final String key, [final Map<String, dynamic> params]) {
    if (params == null) {
      return localizedStrings[key];
    } else {
      return interpolation.eval(localizedStrings[key], params);
    }
  }
}

/// LocalizationsDelegate is a factory for a set of localized resources
/// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(final Locale locale) {
    // Include all of your supported language codes here
    return AppLocalizations.supportedLocales().map((e) => e.languageCode).toList().contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(final Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(final _AppLocalizationsDelegate old) => false;
}
