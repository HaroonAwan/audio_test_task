class Phrases {
  Phrases({
    required this.words,
    required this.time,
  });

  String words;
  int time;

  @override
  bool operator ==(Object other) {
    return (other is Phrases && other.time == time);
  }

  @override
  int get hashCode => time.hashCode;

  @override
  String toString() => '$words $time';
}
