library show_grid;
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'contacts.dart';
import 'add.dart';

/**
 * Display contacts as grid.
 */
@CustomTag('show-grid')
class ShowGrid extends PolymerElement {
  
  /// list of contacts
  @observable Map contacts;
  /// selected item.
  var item;
  /// alert div element
  DivElement alert;
  DivElement grid_result;
  /// IndexedDb contacts object
  idbContacts idbC;
  
  /// constructor
  ShowGrid.created() : super.created();
  
  void attached() {
    super.attached();
    idbC = new idbContacts();
    alert = shadowRoot.querySelector('#del_alert');  
    grid_result = shadowRoot.querySelector('#grid_result');
  }
  
  /// Edit contacts
  void edit(Event event, var detail, var target) {
    item = target.id.replaceAll('edi_', '');
    AddContact edit = new Element.tag('add-contact');
    edit.edit = true;
    edit.item = item;
    this.parent.parent.querySelector('#data_form')
      ..style.display = 'block'
      ..nodes.clear()
      ..nodes.add(edit);
    this.parent.style.display = 'none';
  }
  
  /// Delete a contact
  void delete(Event event, var detail, var target) {
    item = target.id.replaceAll('del_', '');
    alert.style.display = 'block';
  }
  
  /// alert close
  void alert_close() => alert_cancel();
  
  /// alert cancel action
  void alert_cancel() {
    item = null;
    alert.style.display = 'none';
  }
  
  /// alert accept action and delete item
  void alert_accept() {
    idbC.delete(item).then((_) {
      contacts.remove(item);
      shadowRoot.querySelector('#tr_${item}').remove();
      grid_result.style.display = 'block';
      alert.style.display = 'none';
    });
  }
  
}

