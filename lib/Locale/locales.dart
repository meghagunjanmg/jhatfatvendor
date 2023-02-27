import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';
import 'package:vendor/Locale/languages.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static Languages language = Languages();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': language.english(),
    'hi': language.hindi(),
  };

  String get bodyText1 {
    return _localizedValues[locale.languageCode]['bodyText1'];
  }

  String get bodyText2 {
    return _localizedValues[locale.languageCode]['bodyText2'];
  }

  String get mobileText {
    return _localizedValues[locale.languageCode]['mobileText'];
  }

  String get continueText {
    return _localizedValues[locale.languageCode]['continueText'];
  }

  String get vegetableText {
    return _localizedValues[locale.languageCode]['vegetableText'];
  }

  String get foodText {
    return _localizedValues[locale.languageCode]['foodText'];
  }

  String get meatText {
    return _localizedValues[locale.languageCode]['meatText'];
  }

  String get medicineText {
    return _localizedValues[locale.languageCode]['medicineText'];
  }

  String get petText {
    return _localizedValues[locale.languageCode]['petText'];
  }

  String get customText {
    return _localizedValues[locale.languageCode]['customText'];
  }

  String get homeText {
    return _localizedValues[locale.languageCode]['homeText'];
  }

  String get orderText {
    return _localizedValues[locale.languageCode]['orderText'];
  }

  String get accountText {
    return _localizedValues[locale.languageCode]['accountText'];
  }

  String get myAccount {
    return _localizedValues[locale.languageCode]['myAccount'];
  }

  String get savedAddresses {
    return _localizedValues[locale.languageCode]['savedAddresses'];
  }

  String get tnc {
    return _localizedValues[locale.languageCode]['tnc'];
  }

  String get support {
    return _localizedValues[locale.languageCode]['support'];
  }

  String get aboutUs {
    return _localizedValues[locale.languageCode]['aboutUs'];
  }

  String get logout {
    return _localizedValues[locale.languageCode]['logout'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
