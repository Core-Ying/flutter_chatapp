
class englishtest {
  final String en;
  final String zh;
  englishtest({this.en, this.zh});

  //类似于initWithJson
  factory englishtest.fromJson(Map json) {
    return englishtest(
      en: json['en'],
      zh: json['zh'],
    );
  }
}


