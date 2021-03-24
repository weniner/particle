// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StringResGenerator
// **************************************************************************

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class R implements WidgetsLocalizations {
  const R();

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  static R string = R();

  static R of(BuildContext context) {
    string = Localizations.of<R>(context, R);
    return string;
  }

  String get App_label => "App_label";

}

class $en extends R {
  const $en();


}

class $zh_CN extends R {
  const $zh_CN();


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<R> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", ""),
      Locale("zh", "CN"),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<R> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "en":
          return SynchronousFuture<R>(const $en());
        case "zh_CN":
          return SynchronousFuture<R>(const $zh_CN());
        default:
        // NO-OP.
      }
    }
    return SynchronousFuture<R>(const R());
  }

  @override
  bool isSupported(Locale locale) =>
      locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

String getLang(Locale l) => l == null
    ? null
    : l.countryCode != null && l.countryCode.isEmpty
        ? l.languageCode
        : l.toString();
    