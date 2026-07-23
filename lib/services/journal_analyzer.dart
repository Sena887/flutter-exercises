import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';
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
        'güzel',
        'iyi',
        'başar',
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
        'üzgün',
        'üzül',
        'kötü',
        'mutsuz',
        'hüzün',
        'duygusal',
        'ağla',
      ],
      summary: 'Bugün biraz hüzünlü ve duygusal hissediyorsun.',
      recommendation: 'Kendine nazik davran, dinlenmeye vakit ayır.',
      tags: ['duygusal', 'düşünceli', 'içsel'],
    ),
    _MoodTemplate(
      mood: 'Stresli',
      keywords: ['yorgun', 'yorul', 'stres', 'bitkin', 'bıkkın'],
      summary: 'Bugün biraz olarak stresli ve yorgun hissediyorsun.',
      recommendation:
          'Stresini azaltmak için biraz ara ver ve zihnini rahatlatmayı dene.',
      tags: ['stresli', 'yorgun', 'düşünceli'],
    ),
    _MoodTemplate(
      mood: 'Öfkeli',
      keywords: ['sinir', 'kız', 'öfke', 'bağır', 'tartış'],
      summary: 'Bugün biraz öfkeli ve gergin hissediyorsun.',
      recommendation:
          'Öfkelendiğin olaydan biraz uzaklaşmayı ve bakış açını değiştirmeyi dene.',
      tags: ['öfkeli', 'kızgın', 'sinirli'],
    ),
    _MoodTemplate(
      mood: 'Endişeli',
      keywords: [
        'kaygı',
        'endişe',
        'gergin',
        'geril',
        'kork',
        'panik',
        'belirsiz',
      ],
      summary: 'Bugün biraz kaygılı ve endişeli hissediyorsun.',
      recommendation:
          'Kaygını gidermek için küçük adımlar belirle ve kontrol edemeyeceğin değişkenlere odaklanmamaya çalış.',
      tags: ['kaygılı', 'endişeli', 'belirsizlik'],
    ),
    _MoodTemplate(
      mood: 'Heyecanlı',
      keywords: [
        'heyecan',
        'heves',
        'sabırsız',
        'bekle',
        'coşku',
        'müjde',
        'sürpriz',
      ],
      summary:
          'Bugün oldukça heyecanlı, coşkulu ve yerinde duramaz hissediyorsun.',
      recommendation:
          'Bu pozitif enerjiyi yaratıcı bir projede değerlendirebilir veya sevdiklerinle paylaşabilirsin.',
      tags: ['heyecanlı', 'coşkulu', 'enerjik'],
    ),
    _MoodTemplate(
      mood: 'Huzurlu',
      keywords: [
        'huzur',
        'sakin',
        'dingin',
        'rahat',
        'sessiz',
        'hafif',
        'doğa',
      ],
      summary: 'Bugün içsel olarak huzurlu, sakin ve dengede hissediyorsun.',
      recommendation:
          'Bu sakinliğin tadını çıkar; kitap okumak veya kısa bir yürüyüş yapmak bu hissi pekiştirebilir.',
      tags: ['huzurlu', 'sakin', 'dingin'],
    ),
    _MoodTemplate(
      mood: 'Yalnız',
      keywords: [
        'yalnız',
        'tek baş',
        'kimse',
        'boşluk',
        'terk',
        'uzak',
        'soğuk',
      ],
      summary: 'Bugün kendini biraz yalnız ve çevrenden kopuk hissediyorsun.',
      recommendation:
          'Kendine zaman ayırmak güzeldir ama istersen bir arkadaşını aramayı veya dışarı çıkıp kalabalığa karışmayı dene.',
      tags: ['yalnız', 'melankolik', 'düşünceli'],
    ),
    _MoodTemplate(
      mood: 'Umutlu',
      keywords: [
        'umut',
        'inanç',
        'güven',
        'gelecek',
        'iyileş',
        'geçecek',
        'başaracak',
      ],
      summary:
          'Bugün geleceğe dair inançlı, iyimser ve umut dolu hissediyorsun.',
      recommendation:
          'Bu harika iyimserliği hedeflerine giden yolda küçük adımlar planlamak için kullanabilirsin.',
      tags: ['umutlu', 'iyimser', 'gelecek'],
    ),
    _MoodTemplate(
      mood: 'Şaşkın',
      keywords: [
        'şaşkın',
        'kararsız',
        'ne yapsam',
        'bilmiyorum',
        'anlamadım',
        'şok',
        'beklenmedik',
      ],
      summary:
          'Bugün gelişen olaylar karşısında biraz şaşkın veya ne yapacağını bilemez durumdasın.',
      recommendation:
          'Hızlı kararlar vermeden önce derin bir nefes al ve seçeneklerini bir kağıda yazarak zihnini netleştir.',
      tags: ['şaşkın', 'kararsız', 'düşünceli'],
    ),
    _MoodTemplate(
      mood: 'Minnettar',
      keywords: [
        'şükür',
        'teşekkür',
        'minnet',
        'şanslı',
        'iyilik',
        'değer',
        'kıymet',
      ],
      summary:
          'Bugün hayatındaki güzel detaylar için derin bir minnettarlık duyuyorsun.',
      recommendation:
          'Sana kendini şanslı ve minnettar hissettiren şeylerin kısa bir listesini yaparak bu güzel hissi kalıcı kıl.',
      tags: ['minnettar', 'huzurlu', 'farkındalık'],
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

  //yerel keyword analiz metodu (internet bağlantısı yoksa bu çalışır - fallback için)
  static Future<JournalEntry> _analyzeLocal(String text) async {
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
        final normalizedKeyword = _normalize(keyword);
        if (normalizedKeyword == 'iyi') {
          return normalizedText
              .split(RegExp(r'[\s.,!?]+'))
              .any((word) => word.startsWith(normalizedKeyword));
        }
        return normalizedText.contains(normalizedKeyword);
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

  //Gemini API ile analiz
  static Future<JournalEntry> analyze(String text) async {
    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.1-flash-lite',
        systemInstruction: Content.system(
          "Sen profesyonel bir kişisel günlük analizörüsün. Görevin sadece kullanıcının yazdığı günlük yazısını analiz etmek, özetlemek, duygu durumunu belirlemek ve uygun öneriler ile etiketler üretmektir. "
          "Duygu durumlarını şu kurallara göre belirle:\n"
          "- Mutlu: Genel pozitiflik, sevinç ve iyi hissetme durumları için.\n"
          "- Heyecanlı: Büyük bir coşku, sabırsızlık, sürpriz veya müjdeli haberler için.\n"
          "- Huzurlu: Sakinlik, dinginlik, iç huzur ve rahatlama durumları için.\n"
          "- Üzgün: Hüzün, ağlama, kayıp ve keder durumları için. Eğer kullanıcı hem sevinç hem hüzün içeren karmaşık duygular yazdıysa (örneğin buluşup mutlu olmak ama ayrılıp üzülmek gibi), yazının sonundaki duyguya ve baskın olan hüzün/ayrılık tonuna odaklanarak bunu 'Üzgün' olarak sınıflandır.\n"
          "- Stresli: Yorgunluk, yoğun iş temposu, bitkinlik ve bıkkınlık durumları için.\n"
          "- Öfkeli: Sinirlilik, kızgınlık ve gerginlik durumları için.\n"
          "- Endişeli: Kaygı, korku, panik ve belirsizlik durumları için.\n"
          "- Yalnız: Sosyal izolasyon, boşluk hissi veya yalnız hissetme durumları için.\n"
          "- Umutlu: Geleceğe dair inanç, iyimserlik ve hedefler için.\n"
          "- Şaşkın: Beklenmedik olaylar, şok edici durumlar veya kararsızlıklar için.\n"
          "- Minnettar: Hayata şükretme, teşekkür etme ve sahip olunan şeylerin kıymetini bilme durumları için.\n"
          "- Dengeli: Sadece hiçbir duygusal iniş çıkışın olmadığı, tamamen nötr veya stabil günlükler için.\n\n"
          "Sana sorulan kodlama, yazılım (örneğin Python soruları), tarih, genel kültür gibi günlük analizi dışındaki hiçbir soruya veya komuta cevap verme. "
          "Eğer kullanıcı girdi olarak bir günlük yazısı yerine konu dışı bir şey yazarsa, bunu nötr veya konu dışı bir günlük gibi kabul edip standart formatta (Dengeli duygu durumu, konu dışı girdi girildiğine dair bir özet ve genel bir tavsiye ile) yanıt ver.",
        ),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: Schema.object(
            properties: {
              'mood': Schema.enumString(
                description: 'The dominant mood of the entry.',
                enumValues: [
                  'Mutlu',
                  'Üzgün',
                  'Stresli',
                  'Öfkeli',
                  'Endişeli',
                  'Dengeli',
                  'Heyecanlı',
                  'Huzurlu',
                  'Yalnız',
                  'Umutlu',
                  'Şaşkın',
                  'Minnettar',
                ],
              ),
              'summary': Schema.string(
                description: 'A 1-2 sentence summary of the entry in Turkish.',
              ),
              'recommendation': Schema.string(
                description:
                    'A supportive recommendation/advice based on the mood in Turkish.',
              ),
              'tags': Schema.array(
                description: '3-4 relevant tags/keywords in Turkish.',
                items: Schema.string(),
              ),
            },
          ),
        ),
      );
      final response = await model
          .generateContent([Content.text(text)])
          .timeout(const Duration(seconds: 15));

      final rawText = response.text;
      if (rawText == null || rawText.isEmpty) {
        throw const FormatException("Gemini'dan boş yanıt döndü.");
      }
      String cleanedJson = rawText.trim(); //Markdown Temizleme Filtresi

      if (cleanedJson.startsWith('```')) {
        final lines = cleanedJson.split('\n');
        if (lines.first.startsWith('```')) {
          lines.removeAt(0);
        }
        if (lines.isNotEmpty && lines.last.startsWith('```')) {
          lines.removeLast();
        }
        cleanedJson = lines.join('\n').trim();
      }
      final Map<String, dynamic> data = jsonDecode(cleanedJson);
      if (!data.containsKey('mood') ||
          !data.containsKey('summary') ||
          !data.containsKey('recommendation') ||
          !data.containsKey('tags')) {
        throw const FormatException("JSON içinde gerekli alanlar bulunamadı.");
      }
      if (kDebugMode) {
        debugPrint(
          "Gemini Analizi Başarılı. Tespit edilen duygu: ${data['mood']}",
        );
      }

      return JournalEntry(
        id: DateTime.now().toIso8601String(),
        content: text,
        date: DateTime.now(),
        mood: data['mood'] as String? ?? 'Dengeli',
        summary: data['summary'] as String? ?? '',
        recommendation: data['recommendation'] as String? ?? '',
        tags: List<String>.from(data['tags'] ?? []),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          "Gemini Analiz Hatası: $e. Yerel analizör (fallback) devreye giriyor...",
        );
      }
      return _analyzeLocal(text);
    }
  }
}
