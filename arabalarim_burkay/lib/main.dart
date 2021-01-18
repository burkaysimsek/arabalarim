import 'dart:convert';

import 'package:arabalarim_burkay/backend/api.dart';
import 'package:arabalarim_burkay/backend/araba_provider.dart';
import 'package:arabalarim_burkay/backend/veri.dart';
import 'package:arabalarim_burkay/screens/arabalistesi.dart';
import 'package:arabalarim_burkay/screens/kayitsayfasi.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    var res = await http.get(Api.araba);
    ArabaFeed category;
    if (res.statusCode == 200) {
      final jsonResponse = json.decode(res.body);
      category = ArabaFeed.fromJson(jsonResponse);
    } else {
      throw ("Error ${res.statusCode}");
    }

    ArabaFeed araba = ArabaFeed();
    DateTime date = new DateTime.now();

    var dateParse = DateTime.parse(date.toString());

    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";
    araba = category;

    final String serverToken =
        'AAAAqGN0JXs:APA91bFvLpdcegJGx51snZ1DXPWUKt52wm4Dcpl-lGTfvQbuefNjQ7tsnIIn5WBuGhLB2HH-BNrkCWCbiHKxhGnwzm4XdQJUu4529xdZ7IcNCSxboiO1P8533AlSJ36Nuo6XqymGMHPZ';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String to;
    await firebaseMessaging.getToken().then((token) {
      to = token;
    });

    Future<Map<String, dynamic>> bildirim(kalangun, arac, kalan) async {
      await firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );

      await http
          .post('https://fcm.googleapis.com/fcm/send',
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=$serverToken',
              },
              body: jsonEncode(
                <String, dynamic>{
                  'notification': <String, dynamic>{
                    'body':
                        '$arac aracınızın $kalan yenileme tarihine kalan gün : $kalangun',
                    'title': 'Hatırlatma'
                  },
                  'priority': 'high',
                  'data': <String, dynamic>{"status": "1"},
                  'to': to,
                },
              ))
          .then((value) => {
                print(value.body),
              });
    }

    for (int i = 0; i < araba.feed.entry.length; i++) {
      Entry entry = araba.feed.entry[i];
      print(entry.sigorta_yenileme);
      print(entry.muayne_yenileme);
      DateTime dateParse1 = DateTime.parse(entry.muayne_yenileme);
      DateTime dateParse2 = DateTime.parse(entry.sigorta_yenileme);
      final skalangun = dateParse2.difference(DateTime.now()).inDays;
      final mkalangun = dateParse1.difference(DateTime.now()).inDays;

      if (skalangun == 5) {
        await bildirim(skalangun, entry.model, "sigorta");
      } else if (skalangun == 1) {
        await bildirim(skalangun, entry.model, "sigorta");
      } else if (skalangun == 7) {
        await bildirim(skalangun, entry.model, "sigorta");
      } else if (skalangun == 2) {
        await bildirim(skalangun, entry.model, "sigorta");
      }
      if (mkalangun == 5) {
        await bildirim(mkalangun, entry.model, "muayne");
      } else if (mkalangun == 1) {
        await bildirim(mkalangun, entry.model, "muayne");
      } else if (mkalangun == 7) {
        await bildirim(mkalangun, entry.model, "muayne");
      } else if (mkalangun == 2) {
        await bildirim(mkalangun, entry.model, "muayne");
      }
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager.registerPeriodicTask("2", "simplePeriodicTask",
      frequency: Duration(minutes: 15),
      existingWorkPolicy: ExistingWorkPolicy.append,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabalarım',
      theme: ThemeData(
        fontFamily: ('Poppins'),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Arabalarim(),
    );
  }
}

class Arabalarim extends StatefulWidget {
  @override
  _ArabalarimState createState() => _ArabalarimState();
}

class _ArabalarimState extends State<Arabalarim>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('status')) {
      // Handle notification message
      final dynamic notification = message['status'];
    }

    // Or do other work.
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  elevation: 1,
                  expandedHeight: 50.0,
                  title: RichText(
                    text: TextSpan(children: [
                      WidgetSpan(
                          child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 17,
                          child: Image.asset(
                            "assets/menu.png",
                          ),
                        ),
                      )),
                      WidgetSpan(
                          child: SizedBox(
                        width: 10,
                      )),
                      TextSpan(
                        text: 'Araba',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins'),
                      ),
                      TextSpan(
                        text: 'larım',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.car_rental),
                      onPressed: () {/* ... */},
                    ),
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(text: "ARABA KAYDET"),
                      Tab(text: "ARABALARIM"),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                            children: [ArabaKayit(), ArabaListesi()]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
