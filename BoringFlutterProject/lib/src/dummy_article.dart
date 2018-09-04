class Article {
  final String text;
  final String url;
  final String by;
  final int time;
  final int score;

  const Article(
      {this.text,
      this.url,
      this.by,
      this.time,
      this.score});

  factory Article.fromJson(Map<String, dynamic> json) {
    String nS = "__";   //Null String
    if(json == null) return null;

    return Article(
      text: json['text'] ?? nS,
      url: json['url'] ?? nS,
      by: json['by'] ?? nS,
      time: json['time'] ?? 0,
      score: json['score'] ?? 0,
    );
  }
}

final fakeArticles = [
  Article(
      text:
          "Circular Shock Acoustic Waves in Ionosphere Triggered by Launch of Formosat-5",
      url: "wiley.com",
      by: "zdw",
      time: 177,
      score: 62),
  Article(
      text: "BMW says electric car mass production not vivable until 2020",
      url: "reuters.com",
      by: "Mononokay",
      time: 81,
      score: 128),
  Article(
      text: "The next SQLite release supports window functions ",
      url: "sqlite.org",
      by: "MarkusWinand",
      time: 60,
      score: 10),
  Article(
      text: "Bullshit-sensitivity predicts prosocial behavior",
      url: "plos.org",
      by: "denzil_correa",
      time: 53,
      score: 31),
  Article(
      text: "Why Software Development Requires Servant Leaders ",
      url: "adl.io",
      by: "mooreds",
      time: 17,
      score: 51),
  Article(
      text: "Production Ramp-Up of a Hardware Startup [pdf] ",
      url: "mit.edu",
      by: "Samsonite",
      time: 9,
      score: 0),
  Article(
      text:
          "Home Hardware will invest in supply chain improvements to drive future growth",
      url: "qwe.com",
      by: "mnb",
      time: 212,
      score: 100),
  Article(
      text:
          "Home Hardware will invest in supply chain improvements to drive future growth",
      url: "wileywards.com",
      by: "rty",
      time: 277,
      score: 162),
  Article(
      text:
          "Home Depot’s Pickering, Ont., store celebrates 10 years of innovation",
      url: "hackerthon.com",
      by: "hgfg",
      time: 77,
      score: 22),
  Article(
      text: "spoga+gafa garden fair update",
      url: "ooyesd.com",
      by: "bgttyus",
      time: 577,
      score: 62),
  Article(
      text: "CMHC identifies vulnerable spots in Canada’s real estate market",
      url: "aawasilawwwdey.com",
      by: "yyhbfg",
      time: 1177,
      score: 262),
  Article(
      text: "New Lowe’s CEO hits the ground running with executive overhaul",
      url: "aweds.com",
      by: "meuriien",
      time: 566,
      score: 1000),
  Article(
      text: "Home Depot goes after the home décor market",
      url: "alivava.com",
      by: "yuna",
      time: 1109,
      score: 622),
  Article(
      text:
          "Luxury market offers opportunities for dealers willing to step up the experience",
      url: "awes.com",
      by: "lorien",
      time: 109,
      score: 22),
  Article(
      text: "Big boxes turn to task automation to reduce labour costs",
      url: "herte.com",
      by: "yuna",
      time: 12109,
      score: 6222),
  Article(
      text: "What’s really new about RONA’s new-look stores? Just take a look",
      url: "vfser.com",
      by: "deadmau5",
      time: 109,
      score: 2),
];
