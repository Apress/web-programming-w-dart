library add_contact;
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'contacts.dart';
import 'dart:async';

/**
 * Display contacts as block.
 */
@CustomTag('add-contact')
class AddContact extends PolymerElement {
  
  /// Define if we're adding or editing a contact.
  @observable bool edit = false;
  
  /// Item to be edited.
  @observable var item;
  
  /// observable fields
  @observable String fname = '';
  @observable String lname = '';
  @observable String phone = '';
  @observable String email = '';
  @observable String address = '';
  @observable String zip = '';
  @observable String city = '';
  @observable String country = '';
  
  /// info result div element
  DivElement info;
  /// IndexedDb contacts object
  idbContacts idbC;
  
  /// constructor
  AddContact.created() : super.created();
  
  void attached() {
    super.attached();
    idbC = new idbContacts();
    info = shadowRoot.querySelector('#info');
    if(edit == true && item != null) {
      idbC.get(item).then((c) {
        fname = c['fname'];
        lname = c['lname'];
        phone = c['phone'];
        email = c['email'];
        address = c['address'];
        zip = c['zip'];
        city = c['city'];
        country = c['country'];
        
        var full_address = '$address, $zip, $city, $country';
        if(full_address.trim().isNotEmpty) {
          idbC.map(full_address, shadowRoot.querySelector('#contact_map'));
        }
        
      });
    }
  }
    
  /// saves changes
  void save() {
  
    if(fname.isEmpty) {
      info
       ..classes = ['alert', 'alert-danger']
       ..style.display = 'block'
       ..setInnerHtml('Please, type First name for the contact');
      _hide_info();
      return;
    }
    
    var data = {
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'email': email,
      'address': address,
      'zip': zip,
      'city': city,
      'country': country
    };
    if(edit == false) {
      idbC.add(data).then((id) {
        info
        ..classes = ['alert', 'alert-success']
        ..style.display = 'block'
        ..setInnerHtml('Contact saved successfully!');
        _cleanup();
        _hide_info();
      });
    } else {
      idbC.update(item, data).then((_) {
        info
          ..classes = ['alert', 'alert-success']
          ..style.display = 'block'
          ..setInnerHtml('Contact saved successfully!');
          _hide_info();
      });
    }
  }
  
  /// cancel adding new contact
  void cancel() {
    (this.parentNode as Element).style.display = 'none';
    (this.parentNode as Element).previousElementSibling.style.display = 'block';
  }
  
  /// clenaup form
  void _cleanup() {
    fname = '';
    lname = '';
    phone = '';
    email = '';
    address = '';
    zip = '';
    city = '';
    country = '';
  }
  
  /// hide info after 4 seconds
  void _hide_info({int seconds: 4}) {
    new Timer.periodic(new Duration(seconds:seconds), (t) {
      info.style.display = 'none';  
      t.cancel();
    });
    
  }
}

