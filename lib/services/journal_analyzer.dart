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
        'keyif',
        'harika',
        'guzel',
        'iyi',
        'basar',
        'enerji',
        'sevin',
      ],
      summary: 'Bugün genel olarak mutlu ve pozitif hissediyorsun.',
      recommendation:
          'Bu enerjiyi korumak için keyif aldığın aktivitelere devam et.',
      tags: ['pozitif', 'enerjik', 'başarı', 'mutluluk'],
    ),
    _MoodTemplate(
      mood: 'Üzgün',
      keywords: [
        'uzgun',
        'uzul',
        'kotu',
        'mutsuz',
        'huzun',
        'duygusal',
        'agla',
      ],
      summary: 'Bugün biraz hüzünlü ve duygusal hissediyorsun.',
      recommendation: 'Kendine nazik davran, dinlenmeye vakit ayır.',
      tags: ['duygusal', 'düşünceli', 'içsel'],
    ),
    _MoodTemplate(
      mood: 'Stresli',
      keywords: ['yorgun', 'yorul', 'stres', 'bitkin', 'bikkin'],
      summary: 'Bugün biraz olarak stresli ve yorgun hissediyorsun.',
      recommendation:
          'Stresini azaltmak için biraz ara ver ve zihnini rahatlatmayı dene.',
      tags: ['stresli', 'yorgun', 'düşünceli'],
    ),
    _MoodTemplate(
      mood: 'Öfkeli',
      keywords: ['sinir', 'kiz', 'ofke', 'bagir', 'tartis'],
      summary: 'Bugün biraz öfkeli ve gergin hissediyorsun.',
      recommendation:
          'Öfkelendiğin olaydan biraz uzaklaşmayı ve bakış açını değiştirmeyi dene.',
      tags: ['öfkeli', 'kızgın', 'sinirli'],
    ),
    _MoodTemplate(
      mood: 'Endişeli',
      keywords: [
        'kaygi',
        'endise',
        'gergin',
        'geril',
        'kork',
        'panik'
            'belirsiz',
      ],
      summary: 'Bugün biraz kaygılı ve endişeli hissediyorsun.',
      recommendation:
          'Kaygını gidermek için küçük adımlar belirle ve kontrol edemeyeceğin değişkenlere odaklanmamaya çalış.',
      tags: ['kaygılı', 'endişeli', 'belirsizlik'],
    ),
  ];

  //kullanıcı türkçe karakter kullanmasa bile hangi duyguda olduğu anlaşılacak
  static String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  static Future<JournalEntry> analyze(String text) async {
    //gecikme süresi
    await Future.delayed(const Duration(milliseconds: 2500));
    final normalizedText = _normalize(text);

    _MoodTemplate? bestTemplate;
    int maxMatches = 0;
    bool isTie = false;

    //her template için kelimelerle eşleşme sayısını bulur
    for (final template in _templates) {
      //şablondaki kelimelerden kaç tanesi kullanıcının günlük yazısında geçiyor
      final matchesCount = template.keywords.where((keyword) {
        if (keyword == 'iyi') {
          return normalizedText
              .split(RegExp(r'[\s.,!?]+'))
              .any((word) => word.startsWith('iyi'));
        }
        return normalizedText.contains(keyword);
      }).length;

      //eğer şablonun eşleşme sayısı şu ana kadarki en yüksek sayıdan fazlaysa
      if (matchesCount > maxMatches) {
        maxMatches = matchesCount;
        bestTemplate = template;
        isTie = false; //eşitlik bozuldu
      } else if (matchesCount == maxMatches && matchesCount > 0) {
        isTie = true; //duygulardan aynı sayıda varsa eşitlik oluşur
      }
    }

    /*hiç eşleşme bulunamadıysa "maxmatches=0"  ya da iki farklı duygu 
    birbirine eşit çıkarsa o zaman dengeli şablonunu gösterir*/
    final matchedTemplate = (bestTemplate == null || isTie)
        ? const _MoodTemplate(
            mood: 'Dengeli',
            keywords: [],
            summary: 'Bugün genel olarak dengeli ve sakin hissediyorsun.',
            recommendation: 'Kendine vakit ayırarak bu dengeyi korumaya çalış.',
            tags: ['dengeli', 'sakin', 'huzurlu'],
          )
        : bestTemplate;

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
