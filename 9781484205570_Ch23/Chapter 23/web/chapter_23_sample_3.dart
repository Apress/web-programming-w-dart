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

   // full search
   var term1 = 'cyphress';
   idb.search(term1).then((regs) {
    print('Searching for: $term1');
    if(regs.length <= 0) {
      print('No matches found');
    } else {
      print('Found ${regs.length} reg(s)'); // Found 1 reg(s)
      regs.forEach((k,v) {
        print('$k :: ${v['fname']}'); // c_14180570189567842745959 :: Peter
      });
    }
   });

   var term2 = 'Spain';
   idb.search(term2).then((regs) {
    print('Searching for: $term2');
    if(regs.length <= 0) {
      print('No matches found');
    } else {
      print('Found ${regs.length} reg(s)'); // Found 2 reg(s)
      regs.forEach((k,v) {
        print('$k :: ${v['fname']}'); // c_14180570189524856050621 :: Moises
                                      // c_14180570189566459398852 :: Patricia
      });
    }
   });


  });
}