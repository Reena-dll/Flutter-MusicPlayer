import 'package:flutter/material.dart';
import 'package:muzikplayer/index.dart';

void main() {
  runApp(MyApp()); // MyApp'ı Ranlıyoruz. Class MyApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug Etiketi Gizleme
      title: 'Music Player', // Başlık
      theme: ThemeData( // Tema ayarı
          primarySwatch: Colors.pink // Birincil renk
      ),
      home: AnaSayfa(), // AnaSayfa Class'ını çağırıyoruz. O da index Dart Dosyasında. Bu yüzden yukarıda onu import ettik!.
    );
  }
}
