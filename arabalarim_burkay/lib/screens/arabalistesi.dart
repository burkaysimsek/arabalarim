import 'package:arabalarim_burkay/backend/api.dart';
import 'package:arabalarim_burkay/backend/araba_provider.dart';
import 'package:arabalarim_burkay/backend/dialog.dart';
import 'package:arabalarim_burkay/backend/dilaog2.dart';
import 'package:arabalarim_burkay/backend/veri.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArabaListesi extends StatefulWidget {
  @override
  _ArabaKayitState createState() => _ArabaKayitState();
}

class _ArabaKayitState extends State<ArabaListesi> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<HomeProvider>(context, listen: false).arabalariGetir();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String to;

  @override
  Widget build(BuildContext context) {
    firebaseMessaging.getToken().then((token) {
      to = token;
    });
    return Consumer<HomeProvider>(builder:
        (BuildContext context, HomeProvider homeProvider, Widget child) {
      return Scaffold(
        body: homeProvider.loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.only(bottom: 30),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: homeProvider.araba.feed.entry.length,
                  physics: ScrollPhysics(),
                  itemExtent: 80,
                  itemBuilder: (BuildContext context, int index) {
                    Entry entry = homeProvider.araba.feed.entry[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: Container(
                        width: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(entry.aracresim)),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          color: Colors.redAccent,
                        ),
                      ),
                      title: Text(
                        entry.model,
                        textScaleFactor: 1.2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            dialog(context, entry);
                          },
                          icon: Icon(
                            Icons.delete,
                          )),
                      subtitle: Text(entry.adsoyad),
                      onTap: () {
                        dialog2(context, entry);
                      },
                    );
                  },
                ),
              ),
      );
    });
  }

  void dialog2(BuildContext context, Entry entry) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog2(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 15),
                          Column(
                            children: [
                              Container(
                                height: 250,
                                child: PageIndicatorContainer(
                                  child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 400,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  index == 0
                                                      ? entry.aracresim
                                                      : index == 1
                                                          ? Api.imageURL +
                                                              entry.muaynekagidi
                                                          : null,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                  align: IndicatorAlign.bottom,
                                  indicatorSpace: 8.0,
                                  padding: EdgeInsets.all(5.0),
                                  indicatorColor: Colors.grey,
                                  indicatorSelectorColor: Colors.yellow,
                                  shape: IndicatorShape.circle(size: 5.0),
                                  length: 2,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Muayne yenileme tarihiniz : " +
                                  entry.muayne_yenileme),
                              Text("Sigorta yenileme tarihiniz : " +
                                  entry.sigorta_yenileme),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 130,
                                    child: OutlineButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      child: Text(
                                        "Kapat",
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ));
  }

  void dialog(BuildContext context, Entry entry) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                "UYARI",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "${entry.model} aracınızı silmek istediğinizden eminmisiniz?",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 130,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "Sil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => {
                        Api.aracSil(Api.baseURL + "api.php?id=${entry.id}"),
                        Provider.of<HomeProvider>(context, listen: false)
                            .arabalariGetir(),
                        Navigator.pop(context),
                      },
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                      child: Text(
                        "İptal",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
