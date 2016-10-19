library chapter21_contacts.mysql_contacts;

import 'dart:async';
import 'package:sqljocky/sqljocky.dart';

/// Abstract class to manage contacts.
abstract class Contacts {
  /// Creates a new contact.
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
}

/// Concrete class to manage contacts stored on physical storage using MySQL.
/// This class requires sqljocky package.
/// https://pub.dartlang.org/packages/sqljocky
///
/// MySQL DB structure:
///
/// CREATE DATABASE  `dbContacts` ;
/// CREATE TABLE  `dbContacts`.`contacts` (
/// `id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
/// `fname` VARCHAR( 150 ) NOT NULL ,
/// `lname` VARCHAR( 150 ) NULL ,
/// `address` TEXT NULL ,
/// `zip` VARCHAR( 10 ) NULL ,
/// `city` VARCHAR( 150 ) NULL ,
/// `country` VARCHAR( 150 ) NULL ,
/// PRIMARY KEY (  `id` )
/// ) ENGINE = MYISAM ;
class MySQLContacts extends Contacts {

  /// MySQL sqljocky database object.
  ConnectionPool _db;
  /// MySQL host.
  String _host;
  /// MySQL port.
  int _port;
  /// Database name.
  String _dbName;
  /// MySQL default table name.
  String _tableName;
  /// MySQL User name.
  String _user;
  /// MySQL Password.
  String _password;

  /// Constructor.
  MySQLContacts({String host:'localhost', int port:3306,
                 String user:'root', String password:'',
                 String db:'dbContacts', String table:'contacts'}) {
    _host = host;
    _port = port;
    _dbName = db;
    _tableName = table;
    _user = user;
    _password = password;

    if(_password != null && _password.isNotEmpty) {
      _db = new ConnectionPool(host:_host, port:_port, user:_user,
          password:_password, db:_dbName, max:5);
    } else {
      _db = new ConnectionPool(host:_host, port:_port, user:_user,
          db:_dbName, max:5);
    }
  }

  /// Deletes all the information on the `contacts` table.
  Future dropDB() {
    return _db.query("TRUNCATE TABLE $_tableName").then((_) => true);
  }

  /// Closes DB connection.
  void close() => _db.close();

  /// Creates a new contact.
  Future add(Map data) {
    var c = new Completer();
    var fields = data.keys.join(",");
    var q = data.keys.map((_) => '?').join(", ");
    var values = data.values.toList();
    _db.prepare("INSERT INTO $_tableName ($fields) VALUES ($q);").then((query) {
      c.complete(query.execute(values));
    });
    return c.future;
  }

  /// Updates an existing contact.
  Future update(int id, Map data) {
    var c = new Completer();
    var fields = data.keys.map((v) => "$v = ?").join(", ");
    var values = data.values.toList();
    values.add(id);
    _db.prepare("UPDATE $_tableName SET $fields WHERE id = ?;").then((query) {
      c.complete(query.execute(values));
    });
    return c.future;
  }

  /// Deletes an existing contact.
  Future delete(int id) {
    var c = new Completer();
    _db.prepare("DELETE FROM $_tableName WHERE id = ?;").then((query) {
      c.complete(query.execute([id]));
    });
    return c.future;
  }

  /// Gets data for a given contact.
  Future get(int id) {
    var element;
    return _db.prepare("SELECT * FROM $_tableName WHERE id = ?")
    .then((query) => query.execute([id]))
    .then((result) => result.forEach((row) {
      element = {
        'fname': row.fname,
        'lname': row.lname,
        'address': row.address,
        'zip': row.zip,
        'city': row.city,
        'country': row.country};
    }))
    .then((_) => element);
  }

  /// Lists the existing contacts.
  Future list() {
    var results = [];
    return _db.query("SELECT * FROM $_tableName")
    .then((rows) => rows.forEach((row) {
      results.add({
        'id': row.id,
        'fname': row.fname,
        'lname': row.lname,
        'address': row.address,
        'zip': row.zip,
        'city': row.city,
        'country': row.country
      });
    }))
    .then((_) => results);
  }

  /// Search for contacts,
  Future search(String query) {
    query = query.toLowerCase().trim();
    var matches = [];
    var where = """LOWER(fname) like '%$query%' OR 
    LOWER(lname) like '%$query%' OR LOWER(address) like '%$query%' OR 
    LOWER(zip) like '%$query%' OR LOWER(city) like '%$query%' OR 
    LOWER(country) like '%$query%'""";

    return _db.query("SELECT * FROM $_tableName WHERE $where")
    .then((rows) => rows.forEach((row) {
        matches.add({
          'id': row.id,
          'fname': row.fname,
          'lname': row.lname,
          'address': row.address,
          'zip': row.zip,
          'city': row.city,
          'country': row.country
        });
      }))
    .then((_) => matches);
  }

}
