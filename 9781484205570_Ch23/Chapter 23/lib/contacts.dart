library chapter_23_sample.idb_contacts;

import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:lawndart/lawndart.dart';
import 'package:google_maps/google_maps.dart';

/// Abstract class to manage contacts.
abstract class Contacts {
  /// Creates a new contact.
  /// It'll return the new conctact ID.
  Future add(Map data);

  /// Updates an existing contact.
  Future update(var id, Map data);

  /// Deletes an existing contact.
  Future delete(var id);

  /// Gets data for a given contact id.
  Future get(var id);

  /// Lists the existing contacts.
  Future list();

  /// Search for contacts,
  Future search(String query);

  /// Gets map from contact location.
  Future map(String address, String container);
}

/// Concrete class to manage contacts stored on browser using IndexedDb.
/// This class requires lawndart package.
/// https://pub.dartlang.org/packages/lawndart
class IdbContacts extends Contacts {

  /// IndexedDb database object.
  IndexedDbStore _db;
  /// Database name.
  String _dbName;
  /// Database table name.
  String _tableName;

  /// Constructor.
  IdbContacts([String dbName='idbContacts', String tableName='contacts']) {
    _dbName = dbName;
    _tableName = tableName;
    _db = new IndexedDbStore(_dbName, _tableName);
  }

  /// Delete all the information on the DB
  Future dropDB() => _db.open().then((_) => _db.nuke());

  /// Creates a new contact.
  Future add(Map data) {
    var now = new DateTime.now().millisecondsSinceEpoch;
    var rand = new Random().nextDouble().toString().split('.')[1].substring(0, 10);
    var id = 'c_$now$rand';
    return _db.open().then((_) => _db.save(data, id));
  }

  /// Updates an existing contact.
  Future update(String id, Map data) {
    return _db.open().then((_) => _db.save(data, id));
  }

  /// Deletes an existing contact.
  Future delete(String id) {
    return _db.open().then((_) => _db.removeByKey(id));
  }

  /// Gets data for a given contact.
  Future get(String id) {
    return _db.open().then((_) => _db.getByKey(id));
  }

  /// Lists the existing contacts.
  Future<Map> list() {
    var results = {};
    var c = new Completer();
    _db.open().then((_) {
      _db.keys().listen((key) {
        results[key] = _db.getByKey(key);
      }, onDone: () => Future.wait(results.values).then((vals) {
        var i = 0;
        results.forEach((k, v) {
          results[k] = vals[i];
          i++;
        });
        c.complete(results);
      }));
    });
    return c.future;
  }

  /// Search for contacts.
  Future<Map> search(String query) {
    var matches = {};
    var c = new Completer();
    list().then((results) {
      results.forEach((k, v) {
        v.values.forEach((f) {
          if(f.toString().toLowerCase().contains(query.toLowerCase())) {
            matches[k] = v;
          }
        });
      });
      c.complete(matches);
    });
    return c.future;
  }

  Future map(String address, String container) {
    var c = new Completer();
    var req = new GeocoderRequest();
    req.address = address;
    new Geocoder().geocode(req, (results, status) {
      // Get lat,long for the address geocoder
      var latlng = results[0].geometry.location;
      final coords = new LatLng(latlng.lat, latlng.lng);
      // Map
      final mapOptions = new MapOptions()
        ..zoom = 18
        ..center = coords
        ..mapTypeId = MapTypeId.ROADMAP;
      final map = new GMap(querySelector(container), mapOptions);
      // Marker
      final markerOptions = new MarkerOptions()
        ..position = coords
        ..map = map
        ..title = address;
      final marker = new Marker(markerOptions);
      // complete the future.
      c.complete(true);
    });
    return c.future;
  }
}
