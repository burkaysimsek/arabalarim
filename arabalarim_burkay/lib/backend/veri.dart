import 'dart:convert';

import 'package:arabalarim_burkay/backend/api.dart';
import 'package:http/http.dart' as http;

class ArabaFeed {
  String version;
  String encoding;
  Feed feed;

  ArabaFeed({this.version, this.encoding, this.feed});

  ArabaFeed.fromJson(Map<dynamic, dynamic> json) {
    feed = json['feed'] != null ? new Feed.fromJson(json['feed']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.feed != null) {
      data['feed'] = this.feed.toJson();
    }
    return data;
  }
}

class Entry {
  String id, adsoyad, model, km, uretimyili, aracresim, muaynekagidi;
  var sigorta_yenileme, muayne_yenileme;

  Entry({
    this.adsoyad,
    this.model,
    this.km,
    this.uretimyili,
    this.aracresim,
    this.muaynekagidi,
    this.sigorta_yenileme,
    this.muayne_yenileme,
  });

  Entry.fromJson(Map<dynamic, dynamic> json) {
    adsoyad = json['adsoyad'] != null ? json['adsoyad'] : null;
    aracresim = json['aracresim'];
    id = json['id'];
    sigorta_yenileme =
        json['sigorta_yenileme'] != null ? json['sigorta_yenileme'] : null;
    aracresim = json['aracresim'] != null ? json['aracresim'] : null;
    km = json['km'] != null ? json['km'] : null;
    uretimyili = json['uretimyili'] != null ? json['uretimyili'] : null;
    muaynekagidi = json['muaynekagidi'] != null ? json['muaynekagidi'] : null;
    muayne_yenileme =
        json['muayne_yenileme'] != null ? json['muayne_yenileme'] : null;
    model = json['model'] != null ? json['model'] : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<String, dynamic>();
    if (this.adsoyad != null) {
      data['adsoyad'] = this.adsoyad;
    }
    if (this.aracresim != null) {
      data['aracresim'] = this.aracresim;
    }
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.uretimyili != null) {
      data['uretimyili'] = this.uretimyili;
    }
    if (this.model != null) {
      data['model'] = this.model;
    }
    if (this.km != null) {
      data['km'] = this.km;
    }
    if (this.muaynekagidi != null) {
      data['muaynekagidi'] = this.muaynekagidi;
    }
    if (this.muayne_yenileme != null) {
      data['muayne_yenileme'] = this.muayne_yenileme;
    }
    if (this.sigorta_yenileme != null) {
      data['sigorta_yenileme'] = this.sigorta_yenileme;
    }
    return data;
  }
}

class Feed {
  List<Entry> entry;

  Feed({this.entry});

  Feed.fromJson(Map<dynamic, dynamic> json) {
    if (json['entry'] != null) {
      String t = json['entry'].runtimeType.toString();
      if (t == "List<dynamic>" || t == "_GrowableList<dynamic>") {
        entry = new List<Entry>();
        json['entry'].forEach((v) {
          entry.add(new Entry.fromJson(v));
        });
      } else {
        entry = new List<Entry>();
        entry.add(new Entry.fromJson(json['entry']));
      }
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.entry != null) {
      data['entry'] = this.entry.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
