import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import 'books.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data;
  var url = Uri.parse(
      "https://www.kitapyurdu.com/index.php?route=product/best_sellers&page=1&list_id=15&filter_in_stock=1&filter_in_stock=1");

  /*
    resim adresleri   => element.children[3].children[0].children[0].children[0].attributes["src"].toString()
    kitap isimleri    => element.children[4].text
    yayinevi isimleri => element.children[5].text
    yazar isimleri    => element.children[6].text
    liste fiyatları fiyatları   => element.children[9].children[0].text
    kitapyurdu fiyatları => element.children[9].children[0].text
  */

  List<Book> kitaplar = [];

  Future getData() async {
    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);
    var response = document
        .getElementsByClassName("product-grid")[0]
        .getElementsByClassName("product-cr")
        .forEach((element) {
      setState(() {
        kitaplar.add(
          Book(
            resim: element.children[3].children[0].children[0].children[0].attributes["src"].toString(),
            kitapAdi: element.children[4].text.toString(),
            yayinEvi: element.children[5].text.toString(),
            yazar: element.children[6].text.toString(),
            fiyat:element.children[9].children[0].text.toString(),
          ),
        );
      });
    });
  }

  TextStyle _style = TextStyle(
    color: Colors.white,
    fontSize: 15,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text("Web Scraping"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          mainAxisSpacing: 10,
        ),
        itemCount: kitaplar.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
            color: Colors.deepOrangeAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            kitaplar[index].resim),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          index.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text("Kitap ismi : ${kitaplar[index].kitapAdi}", style: _style),
                  Text("Yayın Evi : ${kitaplar[index].yayinEvi}", style: _style),
                  Text("Yazar : ${kitaplar[index].yazar}", style: _style),
                  Text("Fiyat : ${kitaplar[index].fiyat}", style: _style),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
