
import 'package:chapter_23_sample/contacts.dart';

void main() {

  var idb = new IdbContacts();
  // This key [c_14199295715576042394808] must be in your browser.
  idb.get('c_14199295715576042394808').then((contact) {
    var address = """${contact['address']}, ${contact['zip']}, 
  ${contact['city']}, ${contact['country']}""";
    idb.map(address, '#sample_container_id');
  });

}