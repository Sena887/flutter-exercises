import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Antigravity App',
      home: PratikEkrani(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// UI practice screen with validation and hover effects

class PratikEkrani extends StatefulWidget {
  const PratikEkrani({super.key});

  @override
  State<PratikEkrani> createState() => _PratikEkraniState();
}

class _PratikEkraniState extends State<PratikEkrani> {
  final TextEditingController _textController = TextEditingController();
  String? _errorMessage;
  bool _isAnalizHovered = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _ekle() {
    setState(() {
      if (_textController.text.trim().isEmpty) {
        _errorMessage = 'Lütfen bir içerik yazarak göndermeye çalışın!';
      } else {
        _errorMessage = null;
        // İçerik başarıyla eklendiğinde kullanıcıya bildirim gösterelim
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('İçerik başarıyla eklendi!'),
              ],
            ),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Modern, soft background color
      appBar: AppBar(
        title: const Text('Pratik Arayüzü'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header text
                    const Text(
                      'İçerik Analiz ve Ekleme',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Birden fazla satır içeren metin girebilirsiniz.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Multi-line TextField
                    TextField(
                      controller: _textController,
                      maxLines: 6, // Allows multiple lines
                      minLines: 3, // Initial heights
                      keyboardType: TextInputType
                          .multiline, //alt satıra geç (enter) butonu
                      decoration: InputDecoration(
                        labelText: 'Metin Girin',
                        alignLabelWithHint:
                            true, // Labels aligns to top-left for multiline
                        hintText: 'Fikirlerinizi buraya yazın...',
                        errorText: _errorMessage,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(
                            bottom: 50.0,
                          ), // Raise the icon for multiline
                          child: Icon(
                            Icons.description_outlined,
                            color: Colors.indigo,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.indigo,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        //value
                        if (_errorMessage != null && val.trim().isNotEmpty) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Analiz Et Button (Hover underline)
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _isAnalizHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isAnalizHovered = false;
                            });
                          },
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: () {
                              // Tıklanınca herhangi bir işlev yapmaz
                            },
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Text(
                                'Analiz Et',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo,
                                  decoration: _isAnalizHovered
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Ekle Button
                        ElevatedButton(
                          onPressed: _ekle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Ekle',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
