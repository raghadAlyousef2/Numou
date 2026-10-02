// GENERATED: Numou Arabic letters seed (all 28)
// Usage: import 'letters_seed.dart';  See models below.

class QuizItem {
  final String ar; final String en; final String emoji; final String imageAsset; final List<String> imageUrls;
  const QuizItem({required this.ar, required this.en, required this.emoji, required this.imageAsset, required this.imageUrls});
}

class CharacterInfo {
  final String key; final String asset; final List<String> urls;
  const CharacterInfo({required this.key, required this.asset, required this.urls});
}

class LetterSeed {
  final String id; final String glyph;
  final CharacterInfo character;
  final QuizItem pronunciationWord;
  final List<QuizItem> quiz;
  final List<String> letterAlts;
  final List<String> wordAlts;

  const LetterSeed({required this.letterAlts,required this.wordAlts, required this.id, required this.glyph, required this.character, required this.pronunciationWord, required this.quiz});
}
/// --- Letter name alternates (id -> phrases) ---
final Map<String, List<String>> kLetterAltMap = {
  'alif': ['ألف','الف','ا','alif','alef'],
  'baa' : ['باء','با','ب','baa','ba'],
  'taa' : ['تاء','تا','ت','taa','ta'],
  'thaa': ['ثاء','ثا','ث','thaa','tha'],
  'jeem': ['جيم','ج','jeem','jim'],
  'haa' : ['حاء','حا','ح','haa','ha (7a)'],
  'khaa': ['خاء','خا','خ','khaa','kha'],
  'dal' : ['دال','دا','د','dal','da'],
  'dhal': ['ذال','ذا','ذ','dhal','dha'],
  'raa' : ['راء','را','ر','raa','ra'],
  'zaay': ['زاي','زا','ز','zaay','zay','za'],
  'seen': ['سين','سي','س','seen','sin','se'],
  'sheen':['شين','شي','ش','sheen','shin','shi'],
  'sad' : ['صاد','صا','ص','saad','sad'],
  'dad' : ['ضاد','ضا','ض','daad','dad'],
  'taa_marbuta_ta': ['طاء','طا','ط','taa mujazama','ta (ṭ)'],
  'zaa' : ['ظاء','ظا','ظ','zaa (ẓ)','dhaad?'], // keep common confusion
  'ain' : ['عين','عي','ع','ain','ayn','3ein'],
  'ghain': ['غين','غي','غ','ghain','ghayn'],
  'fa'  : ['فاء','فا','ف','fa','faa'],
  'qaf' : ['قاف','قا','ق','qaf','qaf (qaaf)'],
  'kaf' : ['كاف','كا','ك','kaf','kaaf','ka'],
  'lam' : ['لام','لا','ل','lam','laam'],
  'meem': ['ميم','مي','م','meem','mim'],
  'noon': ['نون','نو','ن','noon','nun'],
  'ha'  : ['هاء','ها','ه','haa (h)','ha'],
  'waw' : ['واو','وا','و','waw','waaw','w'],
  'yaa' : ['ياء','يا','ي','yaa','ya'],
};

/// --- Optional word-synonyms per primary pronunciation word (Arabic -> variants) ---
/// Keep these short; add more as you test ASR.
final Map<String, List<String>> kWordSynonyms = {
  // animals / basics
  'أسد': ['اسد','الأسد','شبل','lion'],
  'بط' : ['بطه','بطة','بطّ','duck'],
  'تمساح': ['تفاح','تفاحة','تفاحه','apple'],
  'ثمار': ['فاكهة','فواكه','ثمار','fruit'],
  'جمل': ['جمال','بعير','ناقة','camel'],
  'حوت': ['حيتان','سمك كبير','blue whale','whale'],
  'خروف': ['غنم','نعجة','sheep'],
  'دب': ['الدب','bear'],
  'ذهب': ['دهب','ذهبٍ','gold'],
  'رجل': ['راجل','رجُل','man','men'],
  'زيت': ['زيتون','زيتٍ','oil'],
  'سمك': ['سمكة','سماك','fish'],
  'شمس': ['الشمس','شموس','sun'],
  'صقر': ['باز','نسر','eagle','falcon'],
  'ضفدع': ['ضفادع','frog'],
  'طائر': ['طيور','عصفور','bird'],
  'ظرف': ['مظروف','ظرف بريد','envelope'],
  'علم': ['التعلم','معرفة','knowledge'],
  'غزال': ['ظبي','غزالٍ','gazelle'],
  'فيل': ['افيال','elephant'],
  'قلم': ['اقلام','قلم حبر','pen'],
  'كرسي': ['كرسيٍ','مقعد','chair'],
  'لسان': ['لسانى','tongue'],
  'مفتاح': ['مفاتيح','key'],
  'نجم': ['نجوم','star'],
  'هاتف': ['موبايل','جوال','phone','جهاز'],
  'وجه': ['الوجه','فم؟','face'],
  'يد': ['ايد','الايد','hand'],
};
/// Immutable constants for all 28 Arabic letters
final List<LetterSeed> kLetterSeeds = [
  LetterSeed(
    id: 'alif',
    glyph: 'أ',
    character: const CharacterInfo(
      key: 'lion',
      asset: 'assets/characters/lion.png',
      urls: const ['https://cdn.example.com/characters/lion.png', 'https://img.example.com/numou/characters/lion1.png', 'https://img.example.com/numou/characters/lion2.png'],

    ),
    pronunciationWord: const QuizItem(
      ar: 'أَسَد', en: 'Lion', emoji: '🦁',
      imageAsset: 'assets/characters/lion.png',
      imageUrls: const ['https://cdn.example.com/words/alif/asad.png', 'https://img.example.com/numou/words/alif/asad1.png', 'https://img.example.com/numou/words/alif/asad2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'أَسَد', en: 'Lion', emoji: '🦁', imageAsset: 'assets/characters/lion.png', imageUrls: const ['https://cdn.example.com/words/alif/asad.png', 'https://img.example.com/numou/words/alif/asad1.png', 'https://img.example.com/numou/words/alif/asad2.png']),
      QuizItem(ar: 'أرنب', en: 'Rabbit', emoji: '🐇', imageAsset: 'assets/levels/A/2.png', imageUrls: const ['https://cdn.example.com/words/alif/arnab.png', 'https://img.example.com/numou/words/alif/arnab1.png', 'https://img.example.com/numou/words/alif/arnab2.png']),
      QuizItem(ar: 'إبرة', en: 'Octopus', emoji: '🪡', imageAsset: 'assets/levels/A/3.png', imageUrls: const ['https://cdn.example.com/words/alif/akhtaboot.png', 'https://img.example.com/numou/words/alif/akhtaboot1.png', 'https://img.example.com/numou/words/alif/akhtaboot2.png']),
      QuizItem(ar: 'أرض', en: 'Earth', emoji: '🌍', imageAsset: 'assets/levels/A/4.png', imageUrls: const ['https://cdn.example.com/words/alif/ard.png', 'https://img.example.com/numou/words/alif/ard1.png', 'https://img.example.com/numou/words/alif/ard2.png']),
    ], letterAlts: kLetterAltMap['alif']?? const [], wordAlts: kLetterAltMap['أَسَد']?? const [],
  ),
  LetterSeed(
    id: 'baa',
    glyph: 'ب',
    character: const CharacterInfo(
      key: 'duck',
      asset: 'assets/levels/B/4.png',
      urls: const ['https://cdn.example.com/characters/duck.png', 'https://img.example.com/numou/characters/duck1.png', 'https://img.example.com/numou/characters/duck2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'بط', en: 'Duck', emoji: '🦆',
      imageAsset: 'assets/levels/B/4.png',
      imageUrls: const ['https://cdn.example.com/words/baa/batta.png', 'https://img.example.com/numou/words/baa/batta1.png', 'https://img.example.com/numou/words/baa/batta2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'بط', en: 'Duck', emoji: '🦆', imageAsset: 'assets/levels/B/4.png', imageUrls: const ['https://cdn.example.com/words/baa/batta.png', 'https://img.example.com/numou/words/baa/batta1.png', 'https://img.example.com/numou/words/baa/batta2.png']),
      QuizItem(ar: 'باب', en: 'Door', emoji: '🚪', imageAsset: 'assets/levels/B/3.png', imageUrls: const ['https://cdn.example.com/words/baa/bab.png', 'https://img.example.com/numou/words/baa/bab1.png', 'https://img.example.com/numou/words/baa/bab2.png']),
      QuizItem(ar: 'بحر', en: 'Sea', emoji: '🌊', imageAsset: 'assets/levels/B/2.png', imageUrls: const ['https://cdn.example.com/words/baa/bahr.png', 'https://img.example.com/numou/words/baa/bahr1.png', 'https://img.example.com/numou/words/baa/bahr2.png']),
      QuizItem(ar: 'بيت', en: 'House', emoji: '🏠', imageAsset: 'assets/levels/B/1.png', imageUrls: const ['https://cdn.example.com/words/baa/bayt.png', 'https://img.example.com/numou/words/baa/bayt1.png', 'https://img.example.com/numou/words/baa/bayt2.png']),
    ],letterAlts: kLetterAltMap['baa']?? const [], wordAlts: kLetterAltMap['بط']?? const [],
  ),
  LetterSeed(
    id: 'taa',
    glyph: 'ت',
    character: const CharacterInfo(
      key: 'apple',
      asset: 'assets/levels/C/2.png',
      urls: const ['https://cdn.example.com/characters/apple.png', 'https://img.example.com/numou/characters/apple1.png', 'https://img.example.com/numou/characters/apple2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'تمساح', en: 'Apple', emoji: '🐊',
      imageAsset: 'assets/levels/C/2.png',
      imageUrls: const ['https://cdn.example.com/words/taa/tuffaha.png', 'https://img.example.com/numou/words/taa/tuffaha1.png', 'https://img.example.com/numou/words/taa/tuffaha2.png'],

    ),
    quiz: const [
      QuizItem(ar: 'تفاحة', en: 'Apple', emoji: '🍎', imageAsset: 'assets/levels/C/1.png', imageUrls: const ['https://cdn.example.com/words/taa/tuffah.png', 'https://img.example.com/numou/words/taa/tuffah1.png', 'https://img.example.com/numou/words/taa/tuffah2.png']),
      QuizItem(ar: 'تمساح', en: 'TV', emoji: '🐊', imageAsset: 'assets/levels/C/2.png', imageUrls: const ['https://cdn.example.com/words/taa/telfaz.png', 'https://img.example.com/numou/words/taa/telfaz1.png', 'https://img.example.com/numou/words/taa/telfaz2.png']),
      QuizItem(ar: 'تاج', en: 'Crown', emoji: '👑', imageAsset: 'assets/levels/C/3.png', imageUrls: const ['https://cdn.example.com/words/taa/taj.png', 'https://img.example.com/numou/words/taa/taj1.png', 'https://img.example.com/numou/words/taa/taj2.png']),
      QuizItem(ar: 'تمثال', en: 'Dates', emoji: '🗿', imageAsset: 'assets/levels/C/4.png', imageUrls: const ['https://cdn.example.com/words/taa/tamr.png', 'https://img.example.com/numou/words/taa/tamr1.png', 'https://img.example.com/numou/words/taa/tamr2.png']),
    ],letterAlts: kLetterAltMap['taa']?? const [], wordAlts: kLetterAltMap['تمساح']?? const [],
  ),
  LetterSeed(
    id: 'thaa',
    glyph: 'ث',
    character: const CharacterInfo(
      key: 'Fruit',
      asset: 'assets/levels/D/4.png',
      urls: const ['https://cdn.example.com/characters/fox.png', 'https://img.example.com/numou/characters/fox1.png', 'https://img.example.com/numou/characters/fox2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'ثمار', en: 'Fruit', emoji: '🍇',
      imageAsset: 'assets/levels/D/4.png',
      imageUrls: const ['https://cdn.example.com/words/thaa/tha3lab.png', 'https://img.example.com/numou/words/thaa/tha3lab1.png', 'https://img.example.com/numou/words/thaa/tha3lab2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'ثمار', en: 'Fruit', emoji: '🍇', imageAsset: 'assets/levels/D/4.png', imageUrls: const ['https://cdn.example.com/words/thaa/tha3lab.png', 'https://img.example.com/numou/words/thaa/tha3lab1.png', 'https://img.example.com/numou/words/thaa/tha3lab2.png']),
      QuizItem(ar: 'ثوب', en: 'Thobe', emoji: '👕', imageAsset: 'assets/levels/D/2.png', imageUrls: const ['https://cdn.example.com/words/thaa/thawb.png', 'https://img.example.com/numou/words/thaa/thawb1.png', 'https://img.example.com/numou/words/thaa/thawb2.png']),
      QuizItem(ar: 'ثلج', en: 'Snow', emoji: '❄️', imageAsset: 'assets/levels/D/3.png', imageUrls: const ['https://cdn.example.com/words/thaa/thalj.png', 'https://img.example.com/numou/words/thaa/thalj1.png', 'https://img.example.com/numou/words/thaa/thalj2.png']),
      QuizItem(ar: 'ثعلب', en: 'Fox', emoji: '🦊', imageAsset: 'assets/levels/D/1.png', imageUrls: const ['https://cdn.example.com/words/thaa/thu3ban.png', 'https://img.example.com/numou/words/thaa/thu3ban1.png', 'https://img.example.com/numou/words/thaa/thu3ban2.png']),
    ],letterAlts: kLetterAltMap['thaa']?? const [], wordAlts: kLetterAltMap['ثمار']?? const [],
  ),
  LetterSeed(
    id: 'jeem',
    glyph: 'ج',
    character: const CharacterInfo(
      key: 'camel',
      asset: 'assets/levels/E/1.png',
      urls: const ['https://cdn.example.com/characters/camel.png', 'https://img.example.com/numou/characters/camel1.png', 'https://img.example.com/numou/characters/camel2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'جمل', en: 'Camel', emoji: '🐫',
      imageAsset: 'assets/levels/E/1.png',
      imageUrls: const ['https://cdn.example.com/words/jeem/jamal.png', 'https://img.example.com/numou/words/jeem/jamal1.png', 'https://img.example.com/numou/words/jeem/jamal2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'جمل', en: 'Camel', emoji: '🐫', imageAsset: 'assets/levels/E/1.png', imageUrls: const ['https://cdn.example.com/words/jeem/jamal.png', 'https://img.example.com/numou/words/jeem/jamal1.png', 'https://img.example.com/numou/words/jeem/jamal2.png']),
      QuizItem(ar: 'جبل', en: 'Mountain', emoji: '⛰️', imageAsset: 'assets/levels/E/2.png', imageUrls: const ['https://cdn.example.com/words/jeem/jabal.png', 'https://img.example.com/numou/words/jeem/jabal1.png', 'https://img.example.com/numou/words/jeem/jabal2.png']),
      QuizItem(ar: 'جرس', en: 'Bell', emoji: '🔔', imageAsset: 'assets/levels/E/3.png', imageUrls: const ['https://cdn.example.com/words/jeem/jaras.png', 'https://img.example.com/numou/words/jeem/jaras1.png', 'https://img.example.com/numou/words/jeem/jaras2.png']),
      QuizItem(ar: 'جزر', en: 'Carrot', emoji: '🥕', imageAsset: 'assets/levels/E/4.png', imageUrls: const ['https://cdn.example.com/words/jeem/jazar.png', 'https://img.example.com/numou/words/jeem/jazar1.png', 'https://img.example.com/numou/words/jeem/jazar2.png']),
    ],letterAlts: kLetterAltMap['jeem']?? const [], wordAlts: kLetterAltMap['جمل']?? const [],
  ),
  LetterSeed(
    id: 'haa',
    glyph: 'ح',
    character: const CharacterInfo(
      key: 'bag',
      asset: 'assets/levels/F/4.png',
      urls: const ['https://cdn.example.com/characters/bag.png', 'https://img.example.com/numou/characters/bag1.png', 'https://img.example.com/numou/characters/bag2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'حوت', en: 'Bag', emoji: '🐋',
      imageAsset: 'assets/levels/F/4.png',
      imageUrls: const ['https://cdn.example.com/words/haa/haqeeba.png', 'https://img.example.com/numou/words/haa/haqeeba1.png', 'https://img.example.com/numou/words/haa/haqeeba2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'حوت', en: 'Blue Veil', emoji: '🐋', imageAsset: 'assets/levels/F/4.png', imageUrls: const ['https://cdn.example.com/words/haa/hisan.png', 'https://img.example.com/numou/words/haa/hisan1.png', 'https://img.example.com/numou/words/haa/hisan2.png']),
      QuizItem(ar: 'حمامة', en: 'Pigeon', emoji: '🕊', imageAsset: 'assets/levels/F/2.png', imageUrls: const ['https://cdn.example.com/words/haa/halib.png', 'https://img.example.com/numou/words/haa/halib1.png', 'https://img.example.com/numou/words/haa/halib2.png']),
      QuizItem(ar: 'حديقة', en: 'Garden', emoji: '🌼', imageAsset: 'assets/levels/F/3.png', imageUrls: const ['https://cdn.example.com/words/haa/hadeeqa.png', 'https://img.example.com/numou/words/haa/hadeeqa1.png', 'https://img.example.com/numou/words/haa/hadeeqa2.png']),
      QuizItem(ar: 'حصان', en: 'horse', emoji: '🐎', imageAsset: 'assets/levels/F/1.png', imageUrls: const ['https://cdn.example.com/words/haa/haqeeba.png', 'https://img.example.com/numou/words/haa/haqeeba1.png', 'https://img.example.com/numou/words/haa/haqeeba2.png']),
    ],letterAlts: kLetterAltMap['haa']?? const [], wordAlts: kLetterAltMap['حوت']?? const [],
  ),
  LetterSeed(
    id: 'khaa',
    glyph: 'خ',
    character: const CharacterInfo(
      key: 'sheep',
      asset: 'assets/levels/G/2.png',
      urls: const ['https://cdn.example.com/characters/sheep.png', 'https://img.example.com/numou/characters/sheep1.png', 'https://img.example.com/numou/characters/sheep2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'خروف', en: 'Sheep', emoji: '🐑',
      imageAsset: 'assets/levels/G/2.png',
      imageUrls: const ['https://cdn.example.com/words/khaa/kharouf.png', 'https://img.example.com/numou/words/khaa/kharouf1.png', 'https://img.example.com/numou/words/khaa/kharouf2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'خروف', en: 'Sheep', emoji: '🐑', imageAsset: 'assets/levels/G/2.png', imageUrls: const ['https://cdn.example.com/words/khaa/kharouf.png', 'https://img.example.com/numou/words/khaa/kharouf1.png', 'https://img.example.com/numou/words/khaa/kharouf2.png']),
      QuizItem(ar: 'خيمة', en: 'Tent', emoji: '⛺', imageAsset: 'assets/levels/G/3.png', imageUrls: const ['https://cdn.example.com/words/khaa/khayma.png', 'https://img.example.com/numou/words/khaa/khayma1.png', 'https://img.example.com/numou/words/khaa/khayma2.png']),
      QuizItem(ar: 'خنزير', en: 'Ring', emoji: '🐖', imageAsset: 'assets/levels/G/4.png', imageUrls: const ['https://cdn.example.com/words/khaa/khatam.png', 'https://img.example.com/numou/words/khaa/khatam1.png', 'https://img.example.com/numou/words/khaa/khatam2.png']),
      QuizItem(ar: 'خبز', en: 'Wood', emoji: '🍞', imageAsset: 'assets/levels/G/1.png', imageUrls: const ['https://cdn.example.com/words/khaa/khashab.png', 'https://img.example.com/numou/words/khaa/khashab1.png', 'https://img.example.com/numou/words/khaa/khashab2.png']),
    ],letterAlts: kLetterAltMap['khaa']?? const [], wordAlts: kLetterAltMap['خروف']?? const [],
),

  LetterSeed(
    id: 'dal',
    glyph: 'د',
    character: const CharacterInfo(
      key: 'rooster',
      asset: 'assets/levels/H/1.png',
      urls: const ['https://cdn.example.com/characters/rooster.png', 'https://img.example.com/numou/characters/rooster1.png', 'https://img.example.com/numou/characters/rooster2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'دب', en: 'Bear', emoji: '🐻',
      imageAsset: 'assets/levels/H/1.png',
      imageUrls: const ['https://cdn.example.com/words/dal/dajaj.png', 'https://img.example.com/numou/words/dal/dajaj1.png', 'https://img.example.com/numou/words/dal/dajaj2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'دب', en: 'Bear', emoji: '🐻', imageAsset: 'assets/levels/H/1.png', imageUrls: const ['https://cdn.example.com/words/dal/dajaj.png', 'https://img.example.com/numou/words/dal/dajaj1.png', 'https://img.example.com/numou/words/dal/dajaj2.png']),
      QuizItem(ar: 'دجاجة', en: 'Chicken', emoji: '🐔', imageAsset: 'assets/levels/H/2.png', imageUrls: const ['https://cdn.example.com/words/dal/deek.png', 'https://img.example.com/numou/words/dal/deek1.png', 'https://img.example.com/numou/words/dal/deek2.png']),
      QuizItem(ar: 'دراجة', en: 'Bicycle', emoji: '🚲', imageAsset: 'assets/levels/H/3.png', imageUrls: const ['https://cdn.example.com/words/dal/darraja.png', 'https://img.example.com/numou/words/dal/darraja1.png', 'https://img.example.com/numou/words/dal/darraja2.png']),
      QuizItem(ar: 'دفتر', en: 'Note Book', emoji: '📒', imageAsset: 'assets/levels/H/4.png', imageUrls: const ['https://cdn.example.com/words/dal/dubb.png', 'https://img.example.com/numou/words/dal/dubb1.png', 'https://img.example.com/numou/words/dal/dubb2.png']),
    ],letterAlts: kLetterAltMap['dal']?? const [], wordAlts: kLetterAltMap['دب']?? const [],
  ),
  LetterSeed(
    id: 'dhal',
    glyph: 'ذ',
    character: const CharacterInfo(
      key: 'Gold',
      asset: 'assets/levels/I/2.png',
      urls: const ['https://cdn.example.com/characters/wolf.png', 'https://img.example.com/numou/characters/wolf1.png', 'https://img.example.com/numou/characters/wolf2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'ذهب', en: 'Gold', emoji: '🪙',
      imageAsset: 'assets/levels/I/2.png',
      imageUrls: const ['https://cdn.example.com/words/dhal/theb.png', 'https://img.example.com/numou/words/dhal/theb1.png', 'https://img.example.com/numou/words/dhal/theb2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'ذهب', en: 'Gold', emoji: '🪙', imageAsset: 'assets/levels/I/2.png', imageUrls: const ['https://cdn.example.com/words/dhal/theb.png', 'https://img.example.com/numou/words/dhal/theb1.png', 'https://img.example.com/numou/words/dhal/theb2.png']),
      QuizItem(ar: 'ذئب', en: 'Wolf', emoji: '🐺', imageAsset: 'assets/levels/I/1.png', imageUrls: const ['https://cdn.example.com/words/dhal/thahab.png', 'https://img.example.com/numou/words/dhal/thahab1.png', 'https://img.example.com/numou/words/dhal/thahab2.png']),
      QuizItem(ar: 'ذراع', en: 'Arm', emoji: '💪', imageAsset: 'assets/levels/I/3.png', imageUrls: const ['https://cdn.example.com/words/dhal/thiraa.png', 'https://img.example.com/numou/words/dhal/thiraa1.png', 'https://img.example.com/numou/words/dhal/thiraa2.png']),
      QuizItem(ar: 'ذرة', en: 'Corn', emoji: '🌽', imageAsset: 'assets/levels/I/4.png', imageUrls: const ['https://cdn.example.com/words/dhal/thurah.png', 'https://img.example.com/numou/words/dhal/thurah1.png', 'https://img.example.com/numou/words/dhal/thurah2.png']),
    ],letterAlts: kLetterAltMap['dhal']?? const [], wordAlts: kLetterAltMap['ذهب']?? const [],
  ),
  LetterSeed(
    id: 'raa',
    glyph: 'ر',
    character: const CharacterInfo(
      key: 'Men',
      asset: 'assets/levels/J/2.png',
      urls: const ['https://cdn.example.com/characters/pomegranate.png', 'https://img.example.com/numou/characters/pomegranate1.png', 'https://img.example.com/numou/characters/pomegranate2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'رجل', en: 'Men', emoji: '👨',
      imageAsset: 'assets/levels/J/2.png',
      imageUrls: const ['https://cdn.example.com/words/raa/rummaan.png', 'https://img.example.com/numou/words/raa/rummaan1.png', 'https://img.example.com/numou/words/raa/rummaan2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'رجل', en: 'Men', emoji: '👨', imageAsset: 'assets/levels/J/2.png', imageUrls: const ['https://cdn.example.com/words/raa/rummaan.png', 'https://img.example.com/numou/words/raa/rummaan1.png', 'https://img.example.com/numou/words/raa/rummaan2.png']),
      QuizItem(ar: 'رمان', en: 'Pomegranate', emoji: '🍎', imageAsset: 'assets/levels/J/1.png', imageUrls: const ['https://cdn.example.com/words/raa/rajul.png', 'https://img.example.com/numou/words/raa/rajul1.png', 'https://img.example.com/numou/words/raa/rajul2.png']),
      QuizItem(ar: 'ريشة', en: 'Feather', emoji: '🪶', imageAsset: 'assets/levels/J/3.png', imageUrls: const ['https://cdn.example.com/words/raa/risha.png', 'https://img.example.com/numou/words/raa/risha1.png', 'https://img.example.com/numou/words/raa/risha2.png']),
      QuizItem(ar: 'رصيف', en: 'Footpath', emoji: '🚶‍♂️', imageAsset: 'assets/levels/J/4.png', imageUrls: const ['https://cdn.example.com/words/raa/riyaah.png', 'https://img.example.com/numou/words/raa/riyaah1.png', 'https://img.example.com/numou/words/raa/riyaah2.png']),
    ],letterAlts: kLetterAltMap['raa']?? const [], wordAlts: kLetterAltMap['رجل']?? const [],
  ),
  LetterSeed(
    id: 'zaay',
    glyph: 'ز',
    character: const CharacterInfo(
      key: 'Flower',
      asset: 'assets/levels/K/2.png',
      urls: const ['https://cdn.example.com/characters/giraffe.png', 'https://img.example.com/numou/characters/giraffe1.png', 'https://img.example.com/numou/characters/giraffe2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'زيت', en: 'Oil', emoji: '🫒',
      imageAsset: 'assets/levels/K/2.png',
      imageUrls: const ['https://cdn.example.com/words/zaay/zarafa.png', 'https://img.example.com/numou/words/zaay/zarafa1.png', 'https://img.example.com/numou/words/zaay/zarafa2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'زيت', en: 'Oil', emoji: '🫒', imageAsset: 'assets/levels/K/2.png', imageUrls: const ['https://cdn.example.com/words/zaay/zuhour.png', 'https://img.example.com/numou/words/zaay/zuhour1.png', 'https://img.example.com/numou/words/zaay/zuhour2.png']),
      QuizItem(ar: 'زهرة', en: 'Flower', emoji: '🌸', imageAsset: 'assets/levels/K/1.png', imageUrls: const ['https://cdn.example.com/words/zaay/zarafa.png', 'https://img.example.com/numou/words/zaay/zarafa1.png', 'https://img.example.com/numou/words/zaay/zarafa2.png']),
      QuizItem(ar: 'زرافة', en: 'Giraffee', emoji: '🦒', imageAsset: 'assets/levels/K/3.png', imageUrls: const ['https://cdn.example.com/words/zaay/zayt.png', 'https://img.example.com/numou/words/zaay/zayt1.png', 'https://img.example.com/numou/words/zaay/zayt2.png']),
      QuizItem(ar: 'زهر', en: 'Poison', emoji: '☠️', imageAsset: 'assets/levels/K/4.png', imageUrls: const ['https://cdn.example.com/words/zaay/zirr.png', 'https://img.example.com/numou/words/zaay/zirr1.png', 'https://img.example.com/numou/words/zaay/zirr2.png']),
    ],letterAlts: kLetterAltMap['zaay']?? const [], wordAlts: kLetterAltMap['زيت']?? const [],
  ),
  LetterSeed(
    id: 'seen',
    glyph: 'س',
    character: const CharacterInfo(
      key: 'fish',
      asset: 'assets/levels/L/1.png',
      urls: const ['https://cdn.example.com/characters/fish.png', 'https://img.example.com/numou/characters/fish1.png', 'https://img.example.com/numou/characters/fish2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'سمك', en: 'Fish', emoji: '🐟',
      imageAsset: 'assets/levels/L/1.png',
      imageUrls: const ['https://cdn.example.com/words/seen/samaka.png', 'https://img.example.com/numou/words/seen/samaka1.png', 'https://img.example.com/numou/words/seen/samaka2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'سمك', en: 'Fish', emoji: '🐟', imageAsset: 'assets/levels/L/1.png', imageUrls: const ['https://cdn.example.com/words/seen/samaka.png', 'https://img.example.com/numou/words/seen/samaka1.png', 'https://img.example.com/numou/words/seen/samaka2.png']),
      QuizItem(ar: 'سيارة', en: 'Car', emoji: '🚗', imageAsset: 'assets/levels/L/2.png', imageUrls: const ['https://cdn.example.com/words/seen/safina.png', 'https://img.example.com/numou/words/seen/safina1.png', 'https://img.example.com/numou/words/seen/safina2.png']),
      QuizItem(ar: 'ساعة', en: 'Clock', emoji: '⏰', imageAsset: 'assets/levels/L/3.png', imageUrls: const ['https://cdn.example.com/words/seen/sitara.png', 'https://img.example.com/numou/words/seen/sitara1.png', 'https://img.example.com/numou/words/seen/sitara2.png']),
      QuizItem(ar: 'سلم', en: 'Stairs', emoji: '🪜', imageAsset: 'assets/levels/L/4.png', imageUrls: const ['https://cdn.example.com/words/seen/souq.png', 'https://img.example.com/numou/words/seen/souq1.png', 'https://img.example.com/numou/words/seen/souq2.png']),
    ],letterAlts: kLetterAltMap['seen']?? const [], wordAlts: kLetterAltMap['سمك']?? const [],
  ),
  LetterSeed(
    id: 'sheen',
    glyph: 'ش',
    character: const CharacterInfo(
      key: 'sun',
      asset: 'assets/levels/M/1.png',
      urls: const ['https://cdn.example.com/characters/sun.png', 'https://img.example.com/numou/characters/sun1.png', 'https://img.example.com/numou/characters/sun2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'شمس', en: 'Sun', emoji: '☀️',
      imageAsset: 'assets/levels/M/1.png',
      imageUrls: const ['https://cdn.example.com/words/sheen/shams.png', 'https://img.example.com/numou/words/sheen/shams1.png', 'https://img.example.com/numou/words/sheen/shams2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'شمس', en: 'Sun', emoji: '☀️', imageAsset: 'assets/levels/M/1.png', imageUrls: const ['https://cdn.example.com/words/sheen/shams.png', 'https://img.example.com/numou/words/sheen/shams1.png', 'https://img.example.com/numou/words/sheen/shams2.png']),
      QuizItem(ar: 'شجرة', en: 'Tree', emoji: '🌳', imageAsset: 'assets/levels/M/2.png', imageUrls: const ['https://cdn.example.com/words/sheen/shajara.png', 'https://img.example.com/numou/words/sheen/shajara1.png', 'https://img.example.com/numou/words/sheen/shajara2.png']),
      QuizItem(ar: 'شاطئ', en: 'Beach', emoji: '🏖', imageAsset: 'assets/levels/M/3.png', imageUrls: const ['https://cdn.example.com/words/sheen/shurta.png', 'https://img.example.com/numou/words/sheen/shurta1.png', 'https://img.example.com/numou/words/sheen/shurta2.png']),
      QuizItem(ar: 'شمعة', en: 'Candle', emoji: '️🕯', imageAsset: 'assets/levels/M/4.png', imageUrls: const ['https://cdn.example.com/words/sheen/shati.png', 'https://img.example.com/numou/words/sheen/shati1.png', 'https://img.example.com/numou/words/sheen/shati2.png']),
    ],letterAlts: kLetterAltMap['sheen']?? const [], wordAlts: kLetterAltMap['شمس']?? const [],
  ),
  LetterSeed(
    id: 'sad',
    glyph: 'ص',
    character: const CharacterInfo(
      key: 'Eagle',
      asset: 'assets/levels/N/1.png',
      urls: const ['https://cdn.example.com/characters/falcon.png', 'https://img.example.com/numou/characters/falcon1.png', 'https://img.example.com/numou/characters/falcon2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'صقر', en: 'Eagle', emoji: '🦅',
      imageAsset: 'assets/levels/N/1.png',
      imageUrls: const ['https://cdn.example.com/words/sad/saqr.png', 'https://img.example.com/numou/words/sad/saqr1.png', 'https://img.example.com/numou/words/sad/saqr2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'صقر', en: 'Eagle', emoji: '🦅', imageAsset: 'assets/levels/N/1.png', imageUrls: const ['https://cdn.example.com/words/sad/saqr.png', 'https://img.example.com/numou/words/sad/saqr1.png', 'https://img.example.com/numou/words/sad/saqr2.png']),
      QuizItem(ar: 'صندوق', en: 'Box', emoji: '📦', imageAsset: 'assets/levels/N/2.png', imageUrls: const ['https://cdn.example.com/words/sad/soura.png', 'https://img.example.com/numou/words/sad/soura1.png', 'https://img.example.com/numou/words/sad/soura2.png']),
      QuizItem(ar: 'صابون', en: 'Soap', emoji: '🧼', imageAsset: 'assets/levels/N/3.png', imageUrls: const ['https://cdn.example.com/words/sad/saboun.png', 'https://img.example.com/numou/words/sad/saboun1.png', 'https://img.example.com/numou/words/sad/saboun2.png']),
      QuizItem(ar: 'صحراء', en: 'Desert', emoji: '🏜️', imageAsset: 'assets/levels/N/4.png', imageUrls: const ['https://cdn.example.com/words/sad/sahra.png', 'https://img.example.com/numou/words/sad/sahra1.png', 'https://img.example.com/numou/words/sad/sahra2.png']),
    ],letterAlts: kLetterAltMap['sad']?? const [], wordAlts: kLetterAltMap['صقر']?? const [],
  ),
  LetterSeed(
    id: 'dad',
    glyph: 'ض',
    character: const CharacterInfo(
      key: 'frog',
      asset: 'assets/levels/O/1.png',
      urls: const ['https://cdn.example.com/characters/frog.png', 'https://img.example.com/numou/characters/frog1.png', 'https://img.example.com/numou/characters/frog2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'ضفدع', en: 'Frog', emoji: '🐸',
      imageAsset: 'assets/levels/O/1.png',
      imageUrls: const ['https://cdn.example.com/words/dad/dfida3.png', 'https://img.example.com/numou/words/dad/dfida31.png', 'https://img.example.com/numou/words/dad/dfida32.png'],
    ),
    quiz: const [
      QuizItem(ar: 'ضفدع', en: 'Frog', emoji: '🐸', imageAsset: 'assets/levels/O/1.png', imageUrls: const ['https://cdn.example.com/words/dad/dfida3.png', 'https://img.example.com/numou/words/dad/dfida31.png', 'https://img.example.com/numou/words/dad/dfida32.png']),
      QuizItem(ar: 'ضوء', en: 'Light', emoji: '💡', imageAsset: 'assets/levels/O/4.png', imageUrls: const ['https://cdn.example.com/words/dad/daw.png', 'https://img.example.com/numou/words/dad/daw1.png', 'https://img.example.com/numou/words/dad/daw2.png']),
      QuizItem(ar: 'ضرس', en: 'Molar', emoji: '🦷', imageAsset: 'assets/levels/O/2.png', imageUrls: const ['https://cdn.example.com/words/dad/dirs.png', 'https://img.example.com/numou/words/dad/dirs1.png', 'https://img.example.com/numou/words/dad/dirs2.png']),
      QuizItem(ar: 'ضلع', en: 'District', emoji: '🗺', imageAsset: 'assets/levels/O/3.png', imageUrls: const ['https://cdn.example.com/words/dad/dab3.png', 'https://img.example.com/numou/words/dad/dab31.png', 'https://img.example.com/numou/words/dad/dab32.png']),
    ],letterAlts: kLetterAltMap['dad']?? const [], wordAlts: kLetterAltMap['ضفدع']?? const [],
  ),
  LetterSeed(
    id: 'taa_marbuta_ta',
    glyph: 'ط',
    character: const CharacterInfo(
      key: 'Bird',
      asset: 'assets/levels/P/1.png',
      urls: const ['https://cdn.example.com/characters/plane.png', 'https://img.example.com/numou/characters/plane1.png', 'https://img.example.com/numou/characters/plane2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'طائر', en: 'Bird', emoji: '🐦',
      imageAsset: 'assets/levels/P/1.png',
      imageUrls: const ['https://cdn.example.com/words/ta/taira.png', 'https://img.example.com/numou/words/ta/taira1.png', 'https://img.example.com/numou/words/ta/taira2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'طائر', en: 'Bird', emoji: '🐦', imageAsset: 'assets/levels/P/1.png', imageUrls: const ['https://cdn.example.com/words/ta/taira.png', 'https://img.example.com/numou/words/ta/taira1.png', 'https://img.example.com/numou/words/ta/taira2.png']),
      QuizItem(ar: 'طريق', en: 'Route', emoji: '🛣', imageAsset: 'assets/levels/P/2.png', imageUrls: const ['https://cdn.example.com/words/ta/tifl.png', 'https://img.example.com/numou/words/ta/tifl1.png', 'https://img.example.com/numou/words/ta/tifl2.png']),
      QuizItem(ar: 'طبلة', en: 'Drum', emoji: '🥁', imageAsset: 'assets/levels/P/3.png', imageUrls: const ['https://cdn.example.com/words/ta/tabib.png', 'https://img.example.com/numou/words/ta/tabib1.png', 'https://img.example.com/numou/words/ta/tabib2.png']),
      QuizItem(ar: 'طاولة', en: 'Plate', emoji: '🪑', imageAsset: 'assets/levels/P/4.png', imageUrls: const ['https://cdn.example.com/words/ta/taabaq.png', 'https://img.example.com/numou/words/ta/taabaq1.png', 'https://img.example.com/numou/words/ta/taabaq2.png']),
    ],letterAlts: kLetterAltMap['taa_marbuta_ta']?? const [], wordAlts: kLetterAltMap['طائر']?? const [],
  ),
  LetterSeed(
    id: 'zaa',
    glyph: 'ظ',
    character: const CharacterInfo(
      key: 'Envelope',
      asset: 'assets/levels/Q/1.png',
      urls: const ['https://cdn.example.com/characters/gazelle.png', 'https://img.example.com/numou/characters/gazelle1.png', 'https://img.example.com/numou/characters/gazelle2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'ظرف', en: 'Envelope', emoji: '✉️',
      imageAsset: 'assets/levels/Q/1.png',
      imageUrls: const ['https://cdn.example.com/words/zaa/zharf.png', 'https://img.example.com/numou/words/zaa/zharf1.png', 'https://img.example.com/numou/words/zaa/zharf2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'ظرف', en: 'Envelope', emoji: '✉️', imageAsset: 'assets/levels/Q/1.png', imageUrls: const ['https://cdn.example.com/words/zaa/zharf.png', 'https://img.example.com/numou/words/zaa/zharf1.png', 'https://img.example.com/numou/words/zaa/zharf2.png']),
      QuizItem(ar: 'ظل', en: 'Shadow', emoji: '🌗', imageAsset: 'assets/levels/Q/4.png', imageUrls: const ['https://cdn.example.com/words/zaa/zill.png', 'https://img.example.com/numou/words/zaa/zill1.png', 'https://img.example.com/numou/words/zaa/zill2.png']),
      QuizItem(ar: 'ظفر', en: 'Nail', emoji: '🏆', imageAsset: 'assets/levels/Q/2.png', imageUrls: const ['https://cdn.example.com/words/zaa/zufr.png', 'https://img.example.com/numou/words/zaa/zufr1.png', 'https://img.example.com/numou/words/zaa/zufr2.png']),
      QuizItem(ar: 'ظلام', en: 'Gazelle', emoji: '🌌', imageAsset: 'assets/levels/Q/3.png', imageUrls: const ['https://cdn.example.com/words/zaa/zhaby.png', 'https://img.example.com/numou/words/zaa/zhaby1.png', 'https://img.example.com/numou/words/zaa/zhaby2.png']),
    ],letterAlts: kLetterAltMap['zaa']?? const [], wordAlts: kLetterAltMap['ظرف']?? const [],
  ),
  LetterSeed(
    id: 'ain',
    glyph: 'ع',
    character: const CharacterInfo(
      key: 'Knowledge',
      asset: 'assets/levels/R/3.png',
      urls: const ['https://cdn.example.com/characters/grapes.png', 'https://img.example.com/numou/characters/grapes1.png', 'https://img.example.com/numou/characters/grapes2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'علم', en: 'Knowledge', emoji: '📘',
      imageAsset: 'assets/levels/R/3.png',
      imageUrls: const ['https://cdn.example.com/words/ain/inab.png', 'https://img.example.com/numou/words/ain/inab1.png', 'https://img.example.com/numou/words/ain/inab2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'علم', en: 'Knowledge', emoji: '📘', imageAsset: 'assets/levels/R/3.png', imageUrls: const ['https://cdn.example.com/words/ain/inab.png', 'https://img.example.com/numou/words/ain/inab1.png', 'https://img.example.com/numou/words/ain/inab2.png']),
      QuizItem(ar: 'عنب', en: 'Grapes', emoji: '🍇', imageAsset: 'assets/levels/R/2.png', imageUrls: const ['https://cdn.example.com/words/ain/alam.png', 'https://img.example.com/numou/words/ain/alam1.png', 'https://img.example.com/numou/words/ain/alam2.png']),
      QuizItem(ar: 'عين', en: 'Eye', emoji: '👁️', imageAsset: 'assets/levels/R/1.png', imageUrls: const ['https://cdn.example.com/words/ain/ayn.png', 'https://img.example.com/numou/words/ain/ayn1.png', 'https://img.example.com/numou/words/ain/ayn2.png']),
      QuizItem(ar: 'عصفور', en: 'Sparrow', emoji: '🐦', imageAsset: 'assets/levels/R/4.png', imageUrls: const ['https://cdn.example.com/words/ain/asal.png', 'https://img.example.com/numou/words/ain/asal1.png', 'https://img.example.com/numou/words/ain/asal2.png']),
    ],letterAlts: kLetterAltMap['ain']?? const [], wordAlts: kLetterAltMap['علم']?? const [],
  ),
  LetterSeed(
    id: 'ghain',
    glyph: 'غ',
    character: const CharacterInfo(
      key: 'Gazelle',
      asset: 'assets/levels/S/1.png',
      urls: const ['https://cdn.example.com/characters/gazelle2.png', 'https://img.example.com/numou/characters/gazelle21.png', 'https://img.example.com/numou/characters/gazelle22.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'غزال', en: 'Gazelle', emoji: '🦌',
      imageAsset: 'assets/levels/S/1.png',
      imageUrls: const ['https://cdn.example.com/words/ghain/ghazal.png', 'https://img.example.com/numou/words/ghain/ghazal1.png', 'https://img.example.com/numou/words/ghain/ghazal2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'غزال', en: 'Gazelle', emoji: '🦌', imageAsset: 'assets/levels/S/1.png', imageUrls: const ['https://cdn.example.com/words/ghain/ghazal.png', 'https://img.example.com/numou/words/ghain/ghazal1.png', 'https://img.example.com/numou/words/ghain/ghazal2.png']),
      QuizItem(ar: 'غيمة', en: 'Cloud', emoji: '☁️', imageAsset: 'assets/levels/S/2.png', imageUrls: const ['https://cdn.example.com/words/ghain/ghaym.png', 'https://img.example.com/numou/words/ghain/ghaym1.png', 'https://img.example.com/numou/words/ghain/ghaym2.png']),
      QuizItem(ar: 'غار', en: 'Cave', emoji: '🏞', imageAsset: 'assets/levels/S/3.png', imageUrls: const ['https://cdn.example.com/words/ghain/ghurfa.png', 'https://img.example.com/numou/words/ghain/ghurfa1.png', 'https://img.example.com/numou/words/ghain/ghurfa2.png']),
      QuizItem(ar: 'غصن', en: 'Branch', emoji: '🌿', imageAsset: 'assets/levels/S/4.png', imageUrls: const ['https://cdn.example.com/words/ghain/ghaseel.png', 'https://img.example.com/numou/words/ghain/ghaseel1.png', 'https://img.example.com/numou/words/ghain/ghaseel2.png']),
    ],letterAlts: kLetterAltMap['ghain']?? const [], wordAlts: kLetterAltMap['غزال']?? const [],
  ),
  LetterSeed(
    id: 'fa',
    glyph: 'ف',
    character: const CharacterInfo(
      key: 'elephant',
      asset: 'assets/levels/T/1.png',
      urls: const ['https://cdn.example.com/characters/elephant.png', 'https://img.example.com/numou/characters/elephant1.png', 'https://img.example.com/numou/characters/elephant2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'فيل', en: 'Elephant', emoji: '🐘',
      imageAsset: 'assets/levels/T/1.png',
      imageUrls: const ['https://cdn.example.com/words/fa/feel.png', 'https://img.example.com/numou/words/fa/feel1.png', 'https://img.example.com/numou/words/fa/feel2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'فيل', en: 'Elephant', emoji: '🐘', imageAsset: 'assets/levels/T/1.png', imageUrls: const ['https://cdn.example.com/words/fa/feel.png', 'https://img.example.com/numou/words/fa/feel1.png', 'https://img.example.com/numou/words/fa/feel2.png']),
      QuizItem(ar: 'فم', en: 'Mouth', emoji: '👄', imageAsset: 'assets/levels/T/2.png', imageUrls: const ['https://cdn.example.com/words/fa/fam.png', 'https://img.example.com/numou/words/fa/fam1.png', 'https://img.example.com/numou/words/fa/fam2.png']),
      QuizItem(ar: 'فاكهة', en: 'Fruits', emoji: '🍓', imageAsset: 'assets/levels/T/3.png', imageUrls: const ['https://cdn.example.com/words/fa/farasha.png', 'https://img.example.com/numou/words/fa/farasha1.png', 'https://img.example.com/numou/words/fa/farasha2.png']),
      QuizItem(ar: 'فستان', en: 'Dress', emoji: '👗', imageAsset: 'assets/levels/T/4.png', imageUrls: const ['https://cdn.example.com/words/fa/fajr.png', 'https://img.example.com/numou/words/fa/fajr1.png', 'https://img.example.com/numou/words/fa/fajr2.png']),
    ],letterAlts: kLetterAltMap['fa']?? const [], wordAlts: kLetterAltMap['فيل']?? const [],
  ),
  LetterSeed(
    id: 'qaf',
    glyph: 'ق',
    character: const CharacterInfo(
      key: 'pen',
      asset: 'assets/levels/U/1.png',
      urls: const ['https://cdn.example.com/characters/pen.png', 'https://img.example.com/numou/characters/pen1.png', 'https://img.example.com/numou/characters/pen2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'قلم', en: 'Pen', emoji: '🖊️',
      imageAsset: 'assets/levels/U/1.png',
      imageUrls: const ['https://cdn.example.com/words/qaf/qalam.png', 'https://img.example.com/numou/words/qaf/qalam1.png', 'https://img.example.com/numou/words/qaf/qalam2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'قلم', en: 'Pen', emoji: '🖊️', imageAsset: 'assets/levels/U/1.png', imageUrls: const ['https://cdn.example.com/words/qaf/qalam.png', 'https://img.example.com/numou/words/qaf/qalam1.png', 'https://img.example.com/numou/words/qaf/qalam2.png']),
      QuizItem(ar: 'قلب', en: 'Heart', emoji: '❤️', imageAsset: 'assets/levels/U/3.png', imageUrls: const ['https://cdn.example.com/words/qaf/qamar.png', 'https://img.example.com/numou/words/qaf/qamar1.png', 'https://img.example.com/numou/words/qaf/qamar2.png']),
      QuizItem(ar: 'قطة', en: 'Cat', emoji: '🐱', imageAsset: 'assets/levels/U/2.png', imageUrls: const ['https://cdn.example.com/words/qaf/qitta.png', 'https://img.example.com/numou/words/qaf/qitta1.png', 'https://img.example.com/numou/words/qaf/qitta2.png']),
      QuizItem(ar: 'قوس', en: 'The bow', emoji: '🏹', imageAsset: 'assets/levels/U/4.png', imageUrls: const ['https://cdn.example.com/words/qaf/qitar.png', 'https://img.example.com/numou/words/qaf/qitar1.png', 'https://img.example.com/numou/words/qaf/qitar2.png']),
    ],letterAlts: kLetterAltMap['qaf']?? const [], wordAlts: kLetterAltMap['قلم']?? const [],
  ),
  LetterSeed(
    id: 'kaf',
    glyph: 'ك',
    character: const CharacterInfo(
      key: 'chair',
      asset: 'assets/levels/V/3.png',
      urls: const ['https://cdn.example.com/characters/book.png', 'https://img.example.com/numou/characters/book1.png', 'https://img.example.com/numou/characters/book2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'كرسي', en: 'Chair', emoji: '🪑',
      imageAsset: 'assets/levels/V/3.png',
      imageUrls: const ['https://cdn.example.com/words/kaf/kitab.png', 'https://img.example.com/numou/words/kaf/kitab1.png', 'https://img.example.com/numou/words/kaf/kitab2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'كرسي', en: 'Chair', emoji: '🪑', imageAsset: 'assets/levels/V/3.png', imageUrls: const ['https://cdn.example.com/words/kaf/kitab.png', 'https://img.example.com/numou/words/kaf/kitab1.png', 'https://img.example.com/numou/words/kaf/kitab2.png']),
      QuizItem(ar: 'كتاب', en: 'Book', emoji: '📖', imageAsset: 'assets/levels/V/1.png', imageUrls: const ['https://cdn.example.com/words/kaf/kabir.png', 'https://img.example.com/numou/words/kaf/kabir1.png', 'https://img.example.com/numou/words/kaf/kabir2.png']),
      QuizItem(ar: 'كرة', en: 'Ball', emoji: '⚽', imageAsset: 'assets/levels/V/4.png', imageUrls: const ['https://cdn.example.com/words/kaf/kura.png', 'https://img.example.com/numou/words/kaf/kura1.png', 'https://img.example.com/numou/words/kaf/kura2.png']),
      QuizItem(ar: 'كلب', en: 'Dog', emoji: '🐶', imageAsset: 'assets/levels/V/2.png', imageUrls: const ['https://cdn.example.com/words/kaf/kalb.png', 'https://img.example.com/numou/words/kaf/kalb1.png', 'https://img.example.com/numou/words/kaf/kalb2.png']),
    ],letterAlts: kLetterAltMap['kaf']?? const [], wordAlts: kLetterAltMap['كرسي']?? const [],
  ),
  LetterSeed(
    id: 'lam',
    glyph: 'ل',
    character: const CharacterInfo(
      key: 'tongue',
      asset: 'assets/levels/W/3.png',
      urls: const ['https://cdn.example.com/characters/lemon.png', 'https://img.example.com/numou/characters/lemon1.png', 'https://img.example.com/numou/characters/lemon2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'لسان', en: 'Tongue', emoji: '👅',
      imageAsset: 'assets/levels/W/3.png',
      imageUrls: const ['https://cdn.example.com/words/lam/laymoon.png', 'https://img.example.com/numou/words/lam/laymoon1.png', 'https://img.example.com/numou/words/lam/laymoon2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'لسان', en: 'Tongue', emoji: '👅', imageAsset: 'assets/levels/W/3.png', imageUrls: const ['https://cdn.example.com/words/lam/laymoon.png', 'https://img.example.com/numou/words/lam/laymoon1.png', 'https://img.example.com/numou/words/lam/laymoon2.png']),
      QuizItem(ar: 'لبن', en: 'Milk', emoji: '🥛', imageAsset: 'assets/levels/W/1.png', imageUrls: const ['https://cdn.example.com/words/lam/laban.png', 'https://img.example.com/numou/words/lam/laban1.png', 'https://img.example.com/numou/words/lam/laban2.png']),
      QuizItem(ar: 'ليمون', en: 'Lemon', emoji: '🍋', imageAsset: 'assets/levels/W/2.png', imageUrls: const ['https://cdn.example.com/words/lam/lail.png', 'https://img.example.com/numou/words/lam/lail1.png', 'https://img.example.com/numou/words/lam/lail2.png']),
      QuizItem(ar: 'لعبة', en: 'Toy', emoji: '🧸', imageAsset: 'assets/levels/W/4.png', imageUrls: const ['https://cdn.example.com/words/lam/lisan.png', 'https://img.example.com/numou/words/lam/lisan1.png', 'https://img.example.com/numou/words/lam/lisan2.png']),
    ],letterAlts: kLetterAltMap['lam']?? const [], wordAlts: kLetterAltMap['لسان']?? const [],
  ),
  LetterSeed(
    id: 'meem',
    glyph: 'م',
    character: const CharacterInfo(
      key: 'banana',
      asset: 'assets/levels/X/4.png',
      urls: const ['https://cdn.example.com/characters/banana.png', 'https://img.example.com/numou/characters/banana1.png', 'https://img.example.com/numou/characters/banana2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'مفتاح', en: 'Key', emoji: '🔑',
      imageAsset: 'assets/levels/X/4.png',
      imageUrls: const ['https://cdn.example.com/words/meem/mawz.png', 'https://img.example.com/numou/words/meem/mawz1.png', 'https://img.example.com/numou/words/meem/mawz2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'موزة', en: 'Banana', emoji: '🍌', imageAsset: 'assets/levels/X/2.png', imageUrls: const ['https://cdn.example.com/words/meem/mawz.png', 'https://img.example.com/numou/words/meem/mawz1.png', 'https://img.example.com/numou/words/meem/mawz2.png']),
      QuizItem(ar: 'مدرسة', en: 'School', emoji: '🏫', imageAsset: 'assets/levels/X/3.png', imageUrls: const ['https://cdn.example.com/words/meem/madrasa.png', 'https://img.example.com/numou/words/meem/madrasa1.png', 'https://img.example.com/numou/words/meem/madrasa2.png']),
      QuizItem(ar: 'ماء', en: 'Water', emoji: '💧', imageAsset: 'assets/levels/X/1.png', imageUrls: const ['https://cdn.example.com/words/meem/maa.png', 'https://img.example.com/numou/words/meem/maa1.png', 'https://img.example.com/numou/words/meem/maa2.png']),
      QuizItem(ar: 'مفتاح', en: 'Key', emoji: '🔑', imageAsset: 'assets/levels/X/4.png', imageUrls: const ['https://cdn.example.com/words/meem/miftaah.png', 'https://img.example.com/numou/words/meem/miftaah1.png', 'https://img.example.com/numou/words/meem/miftaah2.png']),
    ],letterAlts: kLetterAltMap['meem']?? const [], wordAlts: kLetterAltMap['مفتاح']?? const [],
  ),
  LetterSeed(
    id: 'noon',
    glyph: 'ن',
    character: const CharacterInfo(
      key: 'tiger',
      asset: 'assets/levels/Y/1.png',
      urls: const ['https://cdn.example.com/characters/tiger.png', 'https://img.example.com/numou/characters/tiger1.png', 'https://img.example.com/numou/characters/tiger2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'نجم', en: 'Star', emoji: '⭐',
      imageAsset: 'assets/levels/Y/1.png',
      imageUrls: const ['https://cdn.example.com/words/noon/namir.png', 'https://img.example.com/numou/words/noon/namir1.png', 'https://img.example.com/numou/words/noon/namir2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'نجم', en: 'Star', emoji: '⭐', imageAsset: 'assets/levels/Y/1.png', imageUrls: const ['https://cdn.example.com/words/noon/namir.png', 'https://img.example.com/numou/words/noon/namir1.png', 'https://img.example.com/numou/words/noon/namir2.png']),
      QuizItem(ar: 'نار', en: 'Star', emoji: '🔥', imageAsset: 'assets/levels/Y/2.png', imageUrls: const ['https://cdn.example.com/words/noon/najm.png', 'https://img.example.com/numou/words/noon/najm1.png', 'https://img.example.com/numou/words/noon/najm2.png']),
      QuizItem(ar: 'نمر', en: 'Window', emoji: '🐆', imageAsset: 'assets/levels/Y/3.png', imageUrls: const ['https://cdn.example.com/words/noon/nafitha.png', 'https://img.example.com/numou/words/noon/nafitha1.png', 'https://img.example.com/numou/words/noon/nafitha2.png']),
      QuizItem(ar: 'نهر', en: 'River', emoji: '🏞🏞', imageAsset: 'assets/levels/Y/4.png', imageUrls: const ['https://cdn.example.com/words/noon/nahr.png', 'https://img.example.com/numou/words/noon/nahr1.png', 'https://img.example.com/numou/words/noon/nahr2.png']),
    ],letterAlts: kLetterAltMap['noon']?? const [], wordAlts: kLetterAltMap['نجم']?? const [],
  ),
  LetterSeed(
    id: 'ha',
    glyph: 'ه',
    character: const CharacterInfo(
      key: 'phone',
      asset: 'assets/levels/Z/2.png',
      urls: const ['https://cdn.example.com/characters/phone.png', 'https://img.example.com/numou/characters/phone1.png', 'https://img.example.com/numou/characters/phone2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'هَاتِف', en: 'Phone', emoji: '📱',
      imageAsset: 'assets/levels/Z/2.png',
      imageUrls: const ['https://cdn.example.com/words/ha/hatif.png', 'https://img.example.com/numou/words/ha/hatif1.png', 'https://img.example.com/numou/words/ha/hatif2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'هَاتِف', en: 'Phone', emoji: '📱', imageAsset: 'assets/levels/Z/2.png', imageUrls: const ['https://cdn.example.com/words/ha/hatif.png', 'https://img.example.com/numou/words/ha/hatif1.png', 'https://img.example.com/numou/words/ha/hatif2.png']),
      QuizItem(ar: 'هدية', en: 'Gift', emoji: '🎁', imageAsset: 'assets/levels/Z/4.png', imageUrls: const ['https://cdn.example.com/words/ha/hadiyya.png', 'https://img.example.com/numou/words/ha/hadiyya1.png', 'https://img.example.com/numou/words/ha/hadiyya2.png']),
      QuizItem(ar: 'هواء', en: 'Air', emoji: '💨', imageAsset: 'assets/levels/Z/3.png', imageUrls: const ['https://cdn.example.com/words/ha/hawa.png', 'https://img.example.com/numou/words/ha/hawa1.png', 'https://img.example.com/numou/words/ha/hawa2.png']),
      QuizItem(ar: 'هلال', en: 'Crescent', emoji: '🌙', imageAsset: 'assets/levels/Z/1.png', imageUrls: const ['https://cdn.example.com/words/ha/hilal.png', 'https://img.example.com/numou/words/ha/hilal1.png', 'https://img.example.com/numou/words/ha/hilal2.png']),
    ],letterAlts: kLetterAltMap['ha']?? const [], wordAlts: kLetterAltMap['هَاتِف']?? const [],
  ),
  LetterSeed(
    id: 'waw',
    glyph: 'و',
    character: const CharacterInfo(
      key: 'face',
      asset: 'assets/levels/ZZ/2.png',
      urls: const ['https://cdn.example.com/characters/rose.png', 'https://img.example.com/numou/characters/rose1.png', 'https://img.example.com/numou/characters/rose2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'وجه', en: 'Face', emoji: '🌹',
      imageAsset: 'assets/levels/ZZ/2.png',
      imageUrls: const ['https://cdn.example.com/words/waw/ward.png', 'https://img.example.com/numou/words/waw/ward1.png', 'https://img.example.com/numou/words/waw/ward2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'وردة', en: 'Rose', emoji: '🌹', imageAsset: 'assets/levels/ZZ/1.png', imageUrls: const ['https://cdn.example.com/words/waw/ward.png', 'https://img.example.com/numou/words/waw/ward1.png', 'https://img.example.com/numou/words/waw/ward2.png']),
      QuizItem(ar: 'ورق', en: 'Leaf', emoji: '🍂', imageAsset: 'assets/levels/ZZ/3.png', imageUrls: const ['https://cdn.example.com/words/waw/watan.png', 'https://img.example.com/numou/words/waw/watan1.png', 'https://img.example.com/numou/words/waw/watan2.png']),
      QuizItem(ar: 'وجه', en: 'Face', emoji: '🙂', imageAsset: 'assets/levels/ZZ/2.png', imageUrls: const ['https://cdn.example.com/words/waw/wajh.png', 'https://img.example.com/numou/words/waw/wajh1.png', 'https://img.example.com/numou/words/waw/wajh2.png']),
      QuizItem(ar: 'وقت', en: 'Time', emoji: '⏳', imageAsset: 'assets/levels/ZZ/4.png', imageUrls: const ['https://cdn.example.com/words/waw/wasaid.png', 'https://img.example.com/numou/words/waw/wasaid1.png', 'https://img.example.com/numou/words/waw/wasaid2.png']),
    ],letterAlts: kLetterAltMap['waw']?? const [], wordAlts: kLetterAltMap['وجه']?? const [],
  ),
  LetterSeed(
    id: 'yaa',
    glyph: 'ي',
    character: const CharacterInfo(
      key: 'hand',
      asset: 'assets/levels/ZZZ/1.png',
      urls: const ['https://cdn.example.com/characters/hand.png', 'https://img.example.com/numou/characters/hand1.png', 'https://img.example.com/numou/characters/hand2.png'],
    ),
    pronunciationWord: const QuizItem(
      ar: 'يد', en: 'Hand', emoji: '✋',
      imageAsset: 'assets/levels/ZZZ/1.png',
      imageUrls: const ['https://cdn.example.com/words/yaa/yad.png', 'https://img.example.com/numou/words/yaa/yad1.png', 'https://img.example.com/numou/words/yaa/yad2.png'],
    ),
    quiz: const [
      QuizItem(ar: 'يد', en: 'Hand', emoji: '✋', imageAsset: 'assets/levels/ZZZ/1.png', imageUrls: const ['https://cdn.example.com/words/yaa/yad.png', 'https://img.example.com/numou/words/yaa/yad1.png', 'https://img.example.com/numou/words/yaa/yad2.png']),
      QuizItem(ar: 'يمامة', en: 'Dove', emoji: '🕊️', imageAsset: 'assets/levels/ZZZ/2.png', imageUrls: const ['https://cdn.example.com/words/yaa/yamama.png', 'https://img.example.com/numou/words/yaa/yamama1.png', 'https://img.example.com/numou/words/yaa/yamama2.png']),
      QuizItem(ar: 'يوسف', en: 'Yousaf', emoji: '👦', imageAsset: 'assets/levels/ZZZ/3.png', imageUrls: const ['https://cdn.example.com/words/yaa/yakht.png', 'https://img.example.com/numou/words/yaa/yakht1.png', 'https://img.example.com/numou/words/yaa/yakht2.png']),
      QuizItem(ar: 'يمن', en: 'Country', emoji: '🗺', imageAsset: 'assets/levels/ZZZ/4.png', imageUrls: const ['https://cdn.example.com/words/yaa/yaqut.png', 'https://img.example.com/numou/words/yaa/yaqut1.png', 'https://img.example.com/numou/words/yaa/yaqut2.png']),
    ],letterAlts: kLetterAltMap['yaa']?? const [], wordAlts: kLetterAltMap['يد']?? const [],
  ),
];