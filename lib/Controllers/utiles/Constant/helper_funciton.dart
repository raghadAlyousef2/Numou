
String titleForPoints(int pts, int total) {
  final p = total == 0 ? 0.0 : pts / total;
  if (p >= 1.0) return 'متميز';
  if (p >= 0.75) return 'ماهر';
  if (p >= 0.5)  return 'خبير';
  if (p >= 0.25) return 'مبتدئ';
  return '';
}

int difficultyFromString(String? s) {
  switch (s?.trim()) {
    case 'سهل':
    case 'easy':
      return 0;
    case 'متوسط':
    case 'meduim':
    case 'medium':
      return 1;
    case 'صعب':
    case 'hard':
      return 2;
    default:
      return 0; // default سهل
  }
}

String difficultyLabelAr(int i) => (['سهل', 'متوسط', 'صعب'])[i.clamp(0, 2)];