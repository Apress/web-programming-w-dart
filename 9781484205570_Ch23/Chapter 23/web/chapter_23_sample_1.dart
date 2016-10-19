
import 'package:chapter_23_sample/contacts.dart';

void main() {

  // Managing contacts on IndexedDb storage.
  var id;
  var idb = new IdbContacts();

  // Adding new contact.
  idb.add({'fname': 'Moises'}).then((k) {
    // new key created for this contact.
    id = k;
    print(id);
    // getting info for the given ID
    return idb.get(id);
  }).then((contact) {
    print(contact);
    return idb.update(id, {'fname': 'Moisés', 'lname': 'Belchín'});
  }).then((_) {
    print('updated');
    // showing changes after updating.
    return idb.get(id);
  }).then((contact) {
    print(contact);
    // After updating we gonna delete the contact.
    return idb.delete(id);
  }).then((_) {
    // getting a nonexistent key will return NULL
    return idb.get(id);
  }).then((contact) => print(contact));

}