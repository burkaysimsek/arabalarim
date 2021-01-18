import 'dart:convert';
import 'dart:io';

import 'package:arabalarim_burkay/backend/api.dart';
import 'package:arabalarim_burkay/backend/veri.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeProvider with ChangeNotifier {
  ArabaFeed araba = ArabaFeed();
  bool loading = true;
  String adsoyad, model, km, uretimyilii, aracresim, muaynekagidi;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  var securetimyili;
  TextEditingController dateController = TextEditingController();
  TextEditingController dateController2 = TextEditingController();

  Future<File> file, file2;

  String base64Image, base64Image2;
  File tmpFile, tmpFile2;

  arabalariGetir() async {
    setLoading(true);
    Api.arabalariGetir(Api.araba).then((araba) {
      setAraba(araba);
      setLoading(false);
    });
  }

  Widget showImage2() {
    return FutureBuilder<File>(
      future: file2,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile2 = snapshot.data;
          base64Image2 = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width / 2 - 30,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Hata',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Resim Seçilmedi',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setDate() {
    dateController.text = DateFormat.yMd().format(DateTime.now());
    dateController2.text = DateFormat.yMd().format(DateTime.now());
    notifyListeners();
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (picked != null) selectedDate = picked;
    dateController.text = DateFormat.yMd().format(selectedDate);
    notifyListeners();
  }

  Future<Null> selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));
    if (picked != null) selectedDate2 = picked;
    dateController2.text = DateFormat.yMd().format(selectedDate2);
    notifyListeners();
  }

  startUpload() {
    if (null == file) {
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    String fileName2 = tmpFile2.path.split('/').last;
    upload(fileName, fileName2);
  }

  upload(String fileName, fileName2) {
    http.post(Api.apiUrl, body: {
      "resim": base64Image,
      "resim_muayne": base64Image2,
      "aracresim": fileName,
      "muaynekagidi": fileName2,
      "adsoyad": adsoyad,
      "km": km,
      "model": model,
      "uretimyili": securetimyili,
      "sigorta_yenileme": selectedDate.toString(),
      "muayne_yenileme": selectedDate2.toString()
    }).then((result) {
      print(result.body);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width / 2 - 30,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Hata',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Resim seçilmedi',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  bool isLoading() {
    return loading;
  }

  void setAraba(value) {
    araba = value;
    notifyListeners();
  }

  ArabaFeed getAraba() {
    return araba;
  }
}
