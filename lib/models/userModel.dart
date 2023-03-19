class User {
  int id;
  String name;
  String email;
  String password;
  List<ChapterProgress>? chapterProgress = [];

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.chapterProgress = const [],
  });

  factory User.fromJson(Map<String, dynamic> user) {
    List<dynamic> chapterProgressList = user['chapterProgress'] ?? [];
    List<ChapterProgress> chapterProgress =
    chapterProgressList.map((cp) => ChapterProgress.fromJson(cp)).toList();
    return User(
      id: user['id'],
      name: user['name'],
      email: user['email'],
      password: user['password'],
      chapterProgress: chapterProgress,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'chapterProgress': chapterProgress!.map((e) => e.toJson()).toList()
  };

  @override
  String toString() {
    return id.toString() + name + email + password + chapterProgress.toString();
  }
}

class ChapterProgress {
  int chapterId;
  List<String>? sectionProgress = [];

  factory ChapterProgress.fromJson(Map<String, dynamic> json) {
    List<dynamic> sectionProgressList = json['sectionProgress'];
    List<String> sectionProgress =
    sectionProgressList.map((cp) => cp.toString()).toList();
    return ChapterProgress(
      chapterId: json['chapterId'],
      sectionProgress: sectionProgress,
    );
  }

  Map<String, dynamic> toJson() => {
    'chapterId': chapterId,
    'sectionProgress': sectionProgress
  };

  ChapterProgress({
    required this.chapterId,
    this.sectionProgress,
  });
}
