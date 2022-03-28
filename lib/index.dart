import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muzikplayer/Model/Sarki.dart';
import 'package:muzikplayer/MusicPlayer.dart';

// Burası bizim JSON verileri listediğimiz sayfanın dart dosyası.


class AnaSayfa extends StatefulWidget { //Statefulwidget ile çalışmamız gerekiyor.
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  Future<List<Sarki>> _getSarki() async{ //ASYNC (Eşzamansız) formatında Future listesi oluşturuyoruz. Sarki.dart'dan ref alıyoruz ve orada ki class sayesinde json dan gelen veriler ilk oraya gidiyor.
    var sarkiData = await http.get("https://api.jsonbin.io/b/6240984c0618276743808bd4"); // Listenin Verilerini http.get fonks. ile URL den alıyoruz.
    var jsonData = json.decode(sarkiData.body); // Bu çektiğimiz verinin body kısmını alarak kodu çözüyoruz. Yani dilin anlayacağı kod bloğuna çeviriyoruz.
    List<Sarki> sarkilar = []; // Listemizden yeni bir nesne türetiyoruz

    for(var sarki in jsonData) // Türettiğimiz nesneye değerlerini verip onu bu for döngüsünde listemize ekleyeceğiz.
      {
        Sarki sarkii = Sarki(sarki["sarkiID"], sarki["sarkici"], sarki["sarkiciFoto"], sarki["sarkiAd"], sarki["sarkiFoto"]);
        // Sarki dartında ki class'a gelen verileri burada nesnemize taşıyoruz.
        sarkilar.add(sarkii); // Nesneyi listeye ekliyoruz. Bunu Foreach mantığıyla yapıyoruz. Ne kadar veri varsa o kadar dönecek.
      }
    return sarkilar; // Nesneyi döndürdüm.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Build de Scaffold döndürüyorum
      appBar: AppBar( // AppBar, Başlık Kısmı
        title:Text("Müzik Kutum",style: TextStyle( // Başlık yazısı ve text'in özellikleri
            fontWeight: FontWeight.bold // Kalınlık
        ),),
        centerTitle: true, // AppBar'ın yazısını ortalayan kod.
      ),
      body: Container( // Body'de Container açtım
        child: FutureBuilder( // İçerisine FutureBuilder açtım. Çünkü classtan gelen json veriyi burada kullanacağıum
            future: _getSarki(), // Future'miz de listemizin metodu
            builder: (BuildContext context, AsyncSnapshot snapshot){ // Snapshot değişkenini kullanacağız
              if(snapshot.data==null){ // Snapshot değişkenin de veri var mı yok mu kontrolü
                return Container(  // Veri yok ise yükleniyor ekranı gelsin
                  child: Center(child: Text("Loading..."),), // Yükleniyor yazısı

                );
              }else{ // Eğer veri geldiyse, Asenkron çalışma olduğu için Yükleniyor yazısının arka planında verileri çekmeye çalışacak.
                return ListView.builder( // Listview açtım. Liste Görüntüleyicisi
                  itemCount: snapshot.data.length, // ListView'imizin eşya sayısı. Yani veriler ne kadar. Burada snapshot'umuzun uzunluğunu veriyoruz. Bu zaten bizim veri uzunluğumuz
                  itemBuilder: (BuildContext context, int index){ // İtem builderin içine inteeger değişkeni ile giriyoruz.
                    return ListTile( // ListTile açıyooruz
                      leading: CircleAvatar( // Leading kısmında CircleAvatar açıyoruz. Buraya fotoğrafları çekeceğiz
                        backgroundImage: NetworkImage(snapshot.data[index].sarkiciFoto), // JSON veride ki fotoğraf verisi link olduğundan dolayı NetworkImage kullandık
                      ),
                      title:Text(snapshot.data[index].sarkiAd), // ListTile'nin başlığını json veriden gelen sarkiAd değişkeni ile belirliyoruz. YAni burada fotonun başlığı Şarkının adı olacak
                      subtitle:Text(snapshot.data[index].sarkici), // Alt başlığı ise şarkıcının ismi olacak.
                      onTap: ()=> Navigator.push(context,
                          // Navigator vasıtası ile hangi şarkıya basılırsa o şarkının sayfasına yönlendirme yapılacak. Ve diğer sayfada kullandığım final değişkenler sayesinde buradan oraya veri taşıyorum
                       new MaterialPageRoute(builder: (context) => MusicPlayer(snapshot.data[index].sarkiID,snapshot.data[index].sarkiAd,snapshot.data[index].sarkici,snapshot.data[index].sarkiFoto))
                    ));
                  },
                );
              }
            }
        ),

      ),

    );
  }
}


