
import 'package:chapter_21_contacts/contacts.dart' show MySQLContacts;

void main() {

  // Managing contacts
  var id;
  var myc = new MySQLContacts();

  // Cleanup database and adding new contact.
  myc.dropDB().then((_) => myc.add({'fname': 'Moises'}))
  .then((contact) {
    id = contact.insertId;
    print(id);
    // getting info for the give ID contact
    return myc.get(id);
  })
  .then((contact) {
    print(contact);
    // updating contact info
    return myc.update(id, {'fname': 'Moisés', 'lname': 'Belchín'});
  })
  .then((_) {
    print('updated');
    // showing changes after updating.
    return myc.get(id);
  })
  .then((contact) {
    print(contact);
    // Deleting the contact.
    return myc.delete(id);
  })
  .then((_) {
    // getting a nonexistent key will return NULL
    return myc.get(id);
  })
  .then((contact) {
    print(contact); // NULL
    // Close DB connection.
    myc.close();
  });

}
