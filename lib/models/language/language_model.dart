/// Language model class.
///
class Language {
  // the country code (IT,AF..)
  final String code;

  // the locale (en, es, da)
  final String locale;

  // the full name of language (English, Danish..)
  final String language;

  // Constructor
  const Language({
    this.code,
    this.locale,
    this.language,
  });
}
