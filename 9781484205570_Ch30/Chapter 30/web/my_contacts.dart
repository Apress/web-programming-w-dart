import 'dart:html';
import 'package:polymer/polymer.dart';
import 'contacts.dart';
import 'grid.dart';
import 'add.dart';

/**
 * Contacts application.
 */
@CustomTag('my-contacts')
class MyContacts extends PolymerElement {
  
  /// IndexedDb idbContacts object.
  idbContacts idbC;
  /// search term.
  @observable String search_term = '';
  /// contacts on database
  Map contacts;
  /// results div container.
  DivElement data_results;
  DivElement info_results;
  DivElement data_form;
  
  /// constructor
  MyContacts.created() : super.created();
  
  /// void attached
  void attached() {
    super.attached();
    data_results = shadowRoot.querySelector('#data_results');
    info_results = shadowRoot.querySelector('#info_results');
    data_form = shadowRoot.querySelector('#data_form');
    idbC = new idbContacts();
    list();
  }
  
  /// list existing contacts on database
  void list() {
    idbC.list().then((results) {
      contacts = results;
      grid();
    });
  }
  
  /// Handles onKeyUp events on search input text.
  void handle_search_input(KeyboardEvent e) {
    if(e.keyCode == KeyCode.ENTER) {
      search();
    }
    if(search_term.trim().isEmpty) {
      info_results
       ..nodes.clear()
       ..classes.clear();
      list();
    }
  }
  
  /// Perform the search.
  void search() {
    if(search_term.trim().isNotEmpty) {
      idbC.search(search_term.trim().toLowerCase()).then((results) {
       if(results.length <= 0) {
         data_results.nodes.clear();
         contacts.clear();
         _show_info_results();         
       } else {
        data_results.nodes.clear();
        contacts = results;
        _show_info_results();
        grid();
       }
      });
    }
  }
  
  /// Display data as grid
  void grid() {
    ShowGrid grid = new Element.tag('show-grid');
    grid.contacts = contacts;
    data_form.style.display = 'none';
    data_results
      ..style.display = 'block'
      ..nodes.clear()
      ..nodes.add(grid);
  }
  
  /// Display the add new contacts form.
  void add() {
    AddContact add = new Element.tag('add-contact');
    data_results.style.display = 'none';
    data_form
      ..style.display = 'block'
      ..nodes.clear()
      ..nodes.add(add);
  }
  
  /// Show info results
  void _show_info_results() {
    if(contacts.length <=0) {
      info_results
        ..nodes.clear()
        ..classes = ['alert', 'alert-warning']
        ..setInnerHtml('No matches found');
    } else {
      info_results
        ..nodes.clear()
        ..classes = ['alert', 'alert-info']
        ..setInnerHtml('Found ${contacts.length} reg(s)');
    }
  }
  
}

