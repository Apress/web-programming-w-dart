import 'dart:async';
import 'package:chapter_23_sample/contacts.dart';

void main() {

  var idb = new IdbContacts();
  // Cleanup the database and add contacts to DB for list and search.
  Future.wait([
   idb.dropDB(),
   idb.add({
     'fname': 'Moises',
     'lname': 'Belchin',
     'address': 'paseo del prado, 28',
     'zip': '28014',
     'city': 'Madrid',
     'country': 'Spain'
   }),
   idb.add({
     'fname': 'Patricia',
     'lname': 'Juberias',
     'address': 'Paseo de la Castellana, 145',
     'zip': '28046',
     'city': 'Madrid',
     'country': 'Spain'
   }),
   idb.add({
     'fname': 'Peter',
     'lname': 'Smith',
     'address': 'Cyphress avenue',
     'zip': '11217',
     'city': 'Brooklyn',
     'country': 'EEUU'
   }),

  ]).then((_) {

    // List all records
   idb.list().then((results) {
    results.forEach((k, v) {
      print('$k :: ${v['fname']}'); // c_14180569406757565057583 :: Moises
                                    // c_14180569406785295107053 :: Patricia
                                    // c_14180569406785694021442 :: Peter
    });
   });
  });
}