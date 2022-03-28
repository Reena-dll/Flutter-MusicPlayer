
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


// Bu sayfa bizim music playerimizin bulunduğu sayfa

class MusicPlayer extends StatefulWidget {
  final int sarkiID;
  final String sarkiAd; // Diğer sayfadan verileri çekebilmek için oluşturulan değişkenler
  final String sarkici;
  final String sarkiFoto;

  MusicPlayer(this.sarkiID,this.sarkiAd, this.sarkici, this.sarkiFoto); // Diğer sayfadan veri almak için sayfa parametresi

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String sarkiAdd, sarkiFotoo, sarkicii,isim; // Bu da statefulwidget olduğu için diğer sayfadan gelen verileri karşılayacak olan değişkenler.
  int sarkiIDD;


  Duration _duration = Duration(); // Duration'dan yeni bir nesne-değişken oluşturdum.
  Duration _position = Duration();// Duration'dan yeni bir nesne-değişken oluşturdum.
  AudioPlayer advancedPlayer; // Çağırdığımız kütüphaneden bir nesne oluşturdum.
  AudioCache audioCache; // Çağırdığımız kütüphaneden bir nesne oluşturdum.
  var blueColor = Color(0xFF090e42); // Tasarımda kullandığım renk ayarı
  var pinkColor = Color(0xFFff6b80);// Tasarımda kullandığım renk ayarı
  @override

  void initState() {
    super.initState();// Diğer sayfadan gelecek olan değişkenleri initState fonksiyonu ile birbirlerine eşitliyoruz.
    sarkiIDD = widget.sarkiID; // Bunu müzikleri çağırırken kullanacağım
    sarkiAdd = widget.sarkiAd; // Bunu da şarkının ismini yazarken kullanıyorum.
    sarkicii = widget.sarkici; // Bu da şarkıcının ismini yazdırırken kullanıyorum
    sarkiFotoo = widget.sarkiFoto; // Bunu da arka planda ki fotoyu çekerken kullanıyorum
    initPlayer(); // initPlayer fonksiyonunu çağırdık.
  }

  void initPlayer(){ // initPlayer fonksiyonu oluşturuyoruz
    advancedPlayer = AudioPlayer(); // Nesnemi tanımlıyorum
    audioCache = AudioCache(fixedPlayer: advancedPlayer); // Nesnemi tanımlıyorum ve sabit değerini belirliyorum.
    advancedPlayer.durationHandler = (d) => setState((){ // Burada işleyici kullanıyorum ve değerleri değişkende tutuyorum
      _duration = d;
    });
    advancedPlayer.positionHandler = (p) => setState((){ // Burada işleyici kullanıyorum ve değerleri değişkende tutuyorum
      _position = p;
    });
  }

  String localFilePath; // Yeni bir string değişken oluşturuyorum.
  
  Widget _tab(List<Widget> children){ // Genel bir widget classı oluşturuyoruz. Parametresi de List
    return Row( // İçerisine Satır açıyoruz.
      mainAxisAlignment: MainAxisAlignment.center, // Satırı ortalıyoruz
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0), // Her yerden 5 piksel uzaklık
          child: Row( // Satır açıyoruz
            children: children // Satırın içerisinde ki childrene fonksiyın kazandırıyoruz.
            .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList() // Bunları da listeliyoruz
          ),
        )
      ],
    );
  }

  Widget _btn (String txt, VoidCallback onPressed){ // Genel bir class oluşturup paramatre bulunduruyoruz. onPressed'e VoidCallBack metodu veriyoruz
    return ButtonTheme( // Buton temalı widgeti return ediyoruz
      minWidth: 48.0, // Minimum genişliğini belirliyorum
      child: Container( // Container' açıyoruz
        width: 75, // Genişlik
        height: 45, // Yükseklik
        child: RaisedButton( // Buton
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), // Butonun şeklini belirliyoruz. Yuvarlak 25 piksel
          child: Text(txt), // Bu bir buton classı olduğu için butona ne yazıalcağını da parametre değişkeni ile belirliyoruz
          color: Colors.pink[900], // Renk
          textColor: Colors.white, // Yazı renk
          onPressed: onPressed ,
        ),
      ),
    );
  }

  Widget slider(){ // Çubuk sınıfı
    return Slider( // Bu bizim müziğin gidişat çubuğu
      activeColor: Colors.black, // Doluluk oran rengi
      inactiveColor: Colors.pink, // Boşluk oran rengi
      value: _position.inSeconds.toDouble(), // Değeri şarkımızın kaçıncı saniyede olduğuna bakarak alıyoruz. Daha önce tuttuğumuz değişkende bu değer var.
      min: 0.0,
      max: _duration.inSeconds.toDouble(), // Max değeri de duration değişkeninde mevcut
      onChanged: (double value){ // Değişiklikleri burada tuttuk.
        setState(() {
          seekToSecond(value.toInt()); // Sınıf çağırdık
          value = value; // Değer kaybolmaması için değeri eşitledik.
        });
      },
    );
  }

  Widget localAudio(){ // Yeni bir sınıf
    return _tab([  // Yukarıda oluşturduğumuz sınıfı return ettik
      _btn('Play', () => audioCache.play('$sarkiIDD.wav')),
      // Yukarıda ki sınıfı çağırarak buton isimlerini ve tıklandığında hangi müzik açılacak onu belirledik. Onu da sarkiID'de ki değerden aldık. ASsets klasörümüzden çekiyoruz.
      _btn('Pause', () => advancedPlayer.pause()), // Bu da durdurma tuşu. Tekrar play'e basıldığında devam ediyor
      _btn('Stop', () => advancedPlayer.stop()), // Bu müziği komple kapatan komut. Tekrar play'e basıldığında kaldığı yerden devam etmez en baştan başlar.

    ]);
  }

  void seekToSecond(int second){
    Duration newDuration = Duration(seconds: second); // Duration'dan yeni bir nesne türettik. Saniyesini değişkenden alıyor. Yukarıda bunu kullanıyoruz.
    advancedPlayer.seek(newDuration); // Bu bizim kaçıncı saniyede olduğumuzu tutarak slider da her hangi bir yere tıkladığımızda şarkıyı oraya saracak komut.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor, // Arka plan rengini yukarıda tanımladığım değişkenden çağırdım
      body: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            child: Stack( // Üst üste widget gelecek durumlarda stack kullanıyoruz.
              children: <Widget>[
                Container(
                    decoration: BoxDecoration( // Konteynır dekarasyonu
                        image: DecorationImage(
                            image: NetworkImage(sarkiFotoo), // Konteynıra arka plan fotosu koyduk. Bunu da json veriden elde ettik.
                            fit: BoxFit.cover))),
                // Sığdırma işlemi yaptık. Fotoyu kutuya sığdırdık
                Container( // Bir Container daha açtık
                  decoration: BoxDecoration( // Dekarasyonunda gradyan açıyoruz
                      gradient: LinearGradient(
                          colors: [blueColor.withOpacity(0.2), blueColor], // Bu gradyana daha önce belirlediğim renkleri vererek opacity ( Görünmezlik ) özelliğini veriyorum.
                          begin: Alignment.topCenter, // Gradyanın başlangıç yeri
                          end: Alignment.bottomCenter)),// Gradyanın bitiş yeri
                ),
                Padding( // Padding içinde yazma sebebim üstte ki widgetleri yerleştirmek
                  padding: const EdgeInsets.symmetric(horizontal: 12.0), // Yatay olarak 12 piksel uzaklık
                  child: Column( // içerisine kolon açtım
                    children: [
                      SizedBox( // 42 piksel boşluk verdim
                        height: 42.0,
                      ),
                      Row( // Satır açtım. Bunu da yukarıdan 42 piksel aşağıda açtım
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,// Eşit boşluk ayarı. Widgetlar arasına eşit boşluk attım
                        children: <Widget>[
                          Container( // Satırda ki ilk container'ımı açtım
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1), // Dekarasyon özelliğinde rengini görünmez beyaz yaptım. Saydamlık
                              borderRadius: BorderRadius.circular(50.0), // Kenarlığını yuvarlak yaptım 50 piksel
                            ),
                            child: FlatButton( // Bu Container'a button görevi verdim
                              onPressed: (){
                                setState(() {
                                  Navigator.pop(context); // Sayfayı patlattım. Yani bir önce ki sayfaya geçiriyor bu metot.
                                });
                              },
                              child: Icon( // İconunu belirleyip rengini seçtim
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column( // Diğer Widget'im ise kolon. Satırın içinde kolon açmamın sebebi şarkıcının ismi ve şarkı ismini yazabilmek
                            children: <Widget>[
                              Text(
                                sarkicii, // İlk text'ime sarkici'nin ismini verdim ve text özelliklerini yazdım
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text( // İkinci textime şarkının adını yazdırdım ve yazının özelliklerini belirledim. Bu text saydam bir text
                                sarkiAdd,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          FlatButton( // Row içerisinde ki 3. widget. Button
                              onPressed: (){
                                try {
                                  setState(() {
                                    Alert(context: context, title:'Sanatçı: '+' $sarkicii',desc: '$sarkiAdd').show(); // Buttonun görevi Alert diyalogu açıp şarkı ismi ve şarkıcının ismini belirtiyor
                                    // Aslında bu alert'e Sarkicinin hakkında bilgi vermek istiyordum, lakin json verime Hakkında kısmını eklemeyi unuttum.
                                  });
                                } catch (e, s) {
                                  print(s); // Eğer hata gelirse Catch'e düş ve hatayı yazdır consola dedim.
                                }
                              },
                              child: Icon(Icons.info, color: Colors.white))
                          // Butonun iconunu belirledim.
                        ],
                      ),
                      Spacer(), // Ara açmak için kullandım. Yukarıda ki widgetler ile aşağıda ki widgetler arasına boşluk atmak için kullanıldı.
                      Text(
                        sarkiAdd, // Şarkının adını büyük bir şekilde yazdırdım.
                        style: TextStyle( // Text'in özellikleri
                          color: Colors.white, // Renk
                          fontWeight: FontWeight.bold, // Kalınlık
                          fontSize: 32.0, // Boyut.
                        ),
                      ),
                      Text(sarkicii, // Onun altına küçük bir şekilde şarkıcının adını yazdırdım.
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6), // Yine saydamlık kullandım.
                              fontSize: 18.0)),
                      SizedBox(
                        height: 32.0, // Alttan 32 piksel boşluk verdim, tam container'in en aşağısına yapışmasın diye.
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row( // Containerden sonra Row açtım ve ortaladım içerisindekileri
            mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[

             Column(// Buraya yukarıda hazırlamış olduğum şarkıyı aç durdur ve kapat butonlarını çağırdım.
               children: [

                 localAudio(), // Görev buttonlarım.
                 slider() // Slider'ı çağırdım. Bu şarkının gidiş çubuğu
               ],
             ),
           ],
          ),
          Spacer(), // Yine belirli bir boşluk bıraktım ve aşağıya süs niyetine Spotify'da ki gibi bileşenler attım
          Row( // Bunları satır içerisine aldım ve eşit aralık bıraktım
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.bookmark_border, color: pinkColor), // İkonlarım.
              Icon(Icons.shuffle, color: pinkColor),
              Icon(Icons.repeat, color: pinkColor)
            ],
          ),
          SizedBox( // Aşağıdan 42 piksel boşluk bıraktım ki tam aşağıya yapışmasın bu Row!
            height: 42.0,
          )
        ],
      ),
    );
  }
}

