import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../models/journal_entry.dart';

class JournalWritingScreen extends StatefulWidget {
  const JournalWritingScreen({super.key});

  @override
  State<JournalWritingScreen> createState() => _JournalWritingScreenState();
}

class _JournalWritingScreenState extends State<JournalWritingScreen> {
  final TextEditingController _journalController =
      TextEditingController(); //yazılan metni kaydetmek için

  JournalEntry? _existingEntry;
  bool _initialized = false;

  late final DateTime now; //late: değer sonradan atanacak

  static const int _minCharacters = 10; //girilecek en az karakter sayısı
  static const int _maxCharacters = 500; //girilecek en fazla karakter sayısı

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is JournalEntry) {
        _existingEntry = arg;
        _journalController.text = arg.content;

        //imleci yazının en sonuna taşı
        _journalController.selection = TextSelection.fromPosition(
          TextPosition(offset: arg.content.length),
        );
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    //memory leak ve RAM kullanımını önlemek için
    _journalController.dispose();
    super.dispose();
  }

  /*save ve build'teki tekrar eden "_journalController.text.trim();" engellendi ve diğer
  yerlerdeki yazımı kısaltıldı*/
  String get _cleanedText => _journalController.text.trim();

  bool get _isTextValid {
    //metin içinde en az bir adet harf olup olmadığını kontrol ediyoruz
    final hasLetter = RegExp(r'\p{L}', unicode: true).hasMatch(_cleanedText);

    return _cleanedText.isNotEmpty &&
        _cleanedText.length >= _minCharacters &&
        _cleanedText.length <= _maxCharacters &&
        hasLetter; //sadece sayı veya sembol varsa geçersiz sayılır
  }

  //analiz etme ve yönlendirme işlemi
  void _save() {
    Navigator.pushNamed(
      context,
      AppRoutes.result,
      arguments: AnalysisArguments(
        text: _cleanedText,
        editEntry: _existingEntry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentLength = _cleanedText.length;

    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _existingEntry != null ? "Günlüğü Düzenle" : "Yeni Günlük Yaz",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tarih Satırı
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: primaryColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Tarih: ${now.day}.${now.month}.${now.year}",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 30, thickness: 1),

                // 10 karakterden azsa
                if (currentLength > 0 && currentLength < _minCharacters)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      "Kaydetmek için en az $_minCharacters girmelisiniz",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                // 500 karakter sınırı aşılmışsa
                else if (currentLength > _maxCharacters)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      "En fazla $_maxCharacters girebilirsiniz",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                //sadece sayı veya sembol girilmişse uyarı mesajı verir
                else if (currentLength > 0 &&
                    !RegExp(r'\p{L}', unicode: true).hasMatch(_cleanedText))
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      "Günlük yazısı sadece sayı veya sembollerden oluşamaz",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                // Metin giriş alanı
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.15),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  constraints: const BoxConstraints(
                    minHeight: 120,
                    maxHeight: 260,
                  ),
                  child: TextField(
                    controller: _journalController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: "Duygularını aktar...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "$currentLength/$_maxCharacters",
                    style: TextStyle(
                      color: currentLength > _maxCharacters
                          ? Colors.red
                          : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isTextValid ? _save : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: _isTextValid ? 3 : 0,
                  ),
                  child: const Text(
                    "Analiz Et",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//analiz ekranına parametre taşımak için kullanılan type safety
class AnalysisArguments {
  final String text;
  final JournalEntry? editEntry;
  const AnalysisArguments({required this.text, this.editEntry});
}
