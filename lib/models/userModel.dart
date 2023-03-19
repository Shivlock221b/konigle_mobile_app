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
    this.chapterProgress
  });

  factory User.fromJson(Map<String, dynamic> user) {
    return User(
      id: user['id'],
      name: user['name'],
      email: user['email'],
      password: user['password'],
      chapterProgress: user['chapterProgress']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'chapterProgress': chapterProgress
  };

  @override
  String toString() {
    return id.toString() + name + email + password + chapterProgress.toString();
  }
}

class ChapterProgress {
  int chapterId;
  List<int>? sectionProgress = [];

  ChapterProgress({
    required this.chapterId,
    this.sectionProgress,
  });
}
