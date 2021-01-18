import 'dart:convert';
import 'dart:io';

import 'package:arabalarim_burkay/backend/api.dart';
import 'package:arabalarim_burkay/backend/araba_provider.dart';
import 'package:arabalarim_burkay/backend/veri.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ArabaKayit extends StatefulWidget {
  @override
  _ArabaKayitState createState() => _ArabaKayitState();
}

List<String> uretimyili = [];

String _setTime, _setDate, _setDate2;

String dateTime;

final formKey = GlobalKey<FormState>();

final snackBar = SnackBar(
  content: const Text('Araç kayıt edildi!'),
  backgroundColor: Colors.blue,
  behavior: SnackBarBehavior.floating,
  duration: const Duration(seconds: 1),
);

class _ArabaKayitState extends State<ArabaKayit> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<HomeProvider>(context, listen: false).setDate();

    for (var i = 1980; i < 2022; i++) {
      uretimyili.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final boyut = MediaQuery.of(context).size;
    return Consumer<HomeProvider>(builder:
        (BuildContext context, HomeProvider homeProvider, Widget child) {
      return Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (String girilenVeri) {
                      if (girilenVeri == "" || girilenVeri == null) {
                        return "Başlık Alanı Boş Bırakılamaz";
                      } else {
                        homeProvider.adsoyad = girilenVeri;
                      }
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Adınız Soyadınız",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    inputFormatters: [],
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Aracınızın Markası",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    validator: (String girilenVeri) {
                      if (girilenVeri == "" || girilenVeri == null) {
                        return "Resim Alanı Boş Bırakılamaz";
                      } else {
                        homeProvider.model = girilenVeri;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Araç km bilgisi",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    validator: (String girilenVeri) {
                      if (girilenVeri == "" || girilenVeri == null) {
                        return "Resim Alanı Boş Bırakılamaz";
                      } else {
                        homeProvider.km = girilenVeri;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    maxHeight: 300,
                    items: uretimyili,
                    hint: "Üretim yılı",
                    onChanged: (value) {
                      homeProvider.securetimyili = value;
                    },
                    showSearchBox: true,
                    searchBoxDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      labelText: "Arama yapın",
                    ),
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Üretim yılı',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SafeArea(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              homeProvider.file = ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 1),
                              ),
                              child: Text(
                                'Aracınızın resmi',
                                style: TextStyle(color: Colors.black87),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SafeArea(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                homeProvider.file2 = ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Theme.of(context).accentColor,
                                      width: 1),
                                ),
                                child: Text(
                                  'Muayne kağıdı resmi',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black87),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      homeProvider.showImage(),
                      homeProvider.showImage2(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sigorta yenileme tarihi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: InkWell(
                                  onTap: () {
                                    homeProvider.selectDate(context);
                                  },
                                  child: Container(
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.red),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: homeProvider.dateController,
                                      onSaved: (String val) {
                                        _setDate = val;
                                      },
                                      decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          contentPadding:
                                              EdgeInsets.only(top: 0.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: 50,
                            child: VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            )),
                        SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Muayne yenileme tarihi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: InkWell(
                                  onTap: () {
                                    homeProvider.selectDate2(context);
                                  },
                                  child: Container(
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.red),
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: homeProvider.dateController2,
                                      onSaved: (String val) {
                                        _setDate2 = val;
                                      },
                                      decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          contentPadding:
                                              EdgeInsets.only(top: 0.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState.validate()) {
                        homeProvider.startUpload();
                        DefaultTabController.of(context).animateTo(1);
                        homeProvider.file = null;
                        homeProvider.file2 = null;
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: boyut.width / 1,
                        height: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal,
                              Colors.teal[200],
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white70),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Aracı Kaydet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ));
    });
  }
}
