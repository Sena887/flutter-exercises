import '../models/journal_entry.dart';
/*Bu yöntemle bilgisayara emretmiyoruz, öğretiyoruz;
mantik ve veri birbirinden ayrıldı, kod okunurluğu arttı */

//her bir duygu durumunun veri template(şablon) yapısı
class _MoodTemplate {
  final String mood;
  final List<String> keywords;
  final String summary;
  final String recommendation;
  final List<String> tags;

  const _MoodTemplate({
    required this.mood,
    required this.keywords,
    required this.summary,
    required this.recommendation,
    required this.tags,
  });
}

class JournalAnalyzer {
  //Tüm duygu durumlarının template(şablon) listesi
  static const List<_MoodTemplate> _templates = [
    _MoodTemplate(
      mood: 'Mutlu',
      keywords: [
        'mutlu',
        'keyifli',
        'harika',
        'güzel',
        'iyi',
        'başarılı',
        'enerjik',
        'sevinçli',
      ],
      summary: 'Bugün genel olarak mutlu ve pozitif hissediyorsun.',
      recommendation:
          'Bu enerjiyi korumak için keyif aldığın aktivitelere devam et.',
      tags: ['pozitif', 'enerjik', 'başarı', 'mutluluk'],
    ),
    _MoodTemplate(
      mood: 'Üzgün',
      keywords: ['üzgün', 'kötü', 'mutsuz', 'hüzünlü', 'duygusal', 'ağlamak'],
      summary: 'Bugün biraz hüzünlü ve duygusal hissediyorsun.',
      recommendation: 'Kendine nazik davran, dinlenmeye vakit ayır.',
      tags: ['duygusal', 'düşünceli', 'içsel'],
    ),
    _MoodTemplate(
      mood: 'Stresli',
      keywords: ['yorgun', 'stresli', 'bitkin', 'endişeli', 'bıkkın'],
      summary: 'Bugün biraz olarak stresli ve yorgun hissediyorsun.',
      recommendation:
          'Stresini azaltmak için biraz ara ver ve zihnini rahatlatmayı dene.',
      tags: ['stresli', 'yorgun', 'düşünceli'],
    ),
    _MoodTemplate(
      mood: 'Öfkeli',
      keywords: ['sinirli', 'kızgın', 'öfkeli', 'bağırmak', 'tartışmak'],
      summary: 'Bugün biraz öfkeli ve gergin hissediyorsun.',
      recommendation:
          'Öfkelendiğin olaydan biraz uzaklaşmayı ve bakış açını değiştirmeyi dene.',
      tags: ['öfkeli', 'kızgın', 'sinirli'],
    ),
    _MoodTemplate(
      mood: 'Endişeli',
      keywords: [
        'kaygılı',
        'endişeli',
        'gergin',
        'kormuş',
        'panik',
        'belirsiz',
      ],
      summary: 'Bugün biraz kaygılı ve endişeli hissediyorsun.',
      recommendation:
          'Kaygını gidermek için küçük adımlar belirle ve kontrol edemeyeceğin değişkenlere odaklanmamaya çalış.',
      tags: ['kaygılı', 'endişeli', 'belirsizlik'],
    ),
  ];

  static Future<JournalEntry> analyze(String text) async {
    //gecikme süresi
    await Future.delayed(const Duration(milliseconds: 2500));
    final lowerText = text.toLowerCase();

    //her duygu durumunu kontrol eder ve ilk eşleşeni bulmaya çalışır
    final matchedTemplate = _templates.firstWhere(
      (template) => template.keywords.any(lowerText.contains),
      //eşleşme olmazsa ekrana 'Dengeli' duygusunu yazdırır
      orElse: () => const _MoodTemplate(
        mood: 'Dengeli',
        keywords: [],
        summary: 'Bugün genel olarak dengeli ve sakin hissediyorsun.',
        recommendation: 'Kendine vakit ayırarak bu dengeyi korumaya çalış.',
        tags: ['dengeli', 'sakin', 'huzurlu'],
      ),
    );

    return JournalEntry(
      id: DateTime.now().toIso8601String(),
      content: text,
      date: DateTime.now(),
      mood: matchedTemplate.mood,
      summary: matchedTemplate.summary,
      recommendation: matchedTemplate.recommendation,
      tags: matchedTemplate.tags,
    );
  }
}
