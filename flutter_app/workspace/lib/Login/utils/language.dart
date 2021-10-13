class MyLanguage {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  MyLanguage(this.id, this.flag, this.name, this.languageCode);

  static List<MyLanguage> languageList() {
    return <MyLanguage>[
      MyLanguage(1, "🇺🇸", "English", "en"),
      MyLanguage(2, "🇺🇸", "Français", "fr"),
      MyLanguage(3, "🇺🇸", "اَلْعَرَبِيَّةُ‎", "ar"),
    ];
  }
}
