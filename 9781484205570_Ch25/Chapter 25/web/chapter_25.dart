import 'dart:html';
import 'dart:math' as Math;

void main() {
  // Different ways to use querySelector.
  var body = document.querySelector('body');
  print(body.innerHtml);
  var h1 = body.querySelector('h1');
  var p = body.querySelector('p');
  var sc = body.querySelector('#sample_container_id');
  var sp = sc.querySelector('#sample_text_id');

  // Change h1 text.
  h1.text = 'Integrating Dart and HTML';
  // Change p text.
  p.text = 'This is an example of using DOM elements from DART';
  // Cleanup p#sample_text_id text.
  sp.text = '';

  // Creating new Elements.
  var input = new InputElement()
    ..id = 'autocomplete'
    ..name = 'autocomplete'
    ..type = 'text'
    ..placeholder = 'Type to search'
    ..width = 40;
  var btnSearch = new ButtonElement()
    ..id = 'btn_search'
    ..name = 'btn_search'
    ..text = 'Search!';
  var btnClear = new ButtonElement()
    ..id = 'btn_clear'
    ..name = 'btn_clear'
    ..text = 'Clear';
  var btnEvents = new ButtonElement()
    ..id = 'btnEvents'
    ..name = 'btnEvents'
    ..text = 'Events Off';
  var br = new BRElement();
  var display = new DivElement()
    ..id = 'display'
    ..classes  = ['terminal'];

  // Setting event handlers.
  var ss_keyup = input.onKeyUp.listen((KeyboardEvent e) {
    var value = e.keyCode.toString();
    showText(display, 'Type: ${value}');
    if(e.keyCode == KeyCode.ENTER) {
      showText(display, 'Searching: ${input.value.toString()} ...');
    }
    if(e.keyCode == KeyCode.ESC) {
      input.value = '';
      display.nodes.clear();
    }
  });

  var ss_cs = btnSearch.onClick.listen((e) {
    if(input.value.trim() == '') {
      showText(display, 'Nothing to search !');
    } else {
      showText(display, 'Searching: ${input.value.toString()} ...');
    }
  });

  var ss_cc = btnClear.onClick.listen((e) {
    input.value = '';
    display.nodes.clear();
  });

  // On/Off events.
  btnEvents.onClick.listen((e) {
    if(btnEvents.text.toLowerCase().contains('off')) {
      btnEvents.text = 'Events On';
      ss_keyup.pause();
      ss_cs.pause();
      ss_cc.pause();
    } else {
      btnEvents.text = 'Events Off';
      ss_keyup.resume();
      ss_cs.resume();
      ss_cc.resume();
    }
  });

  // Adding new elements to DOM
  sp.nodes.addAll([ input, btnSearch, btnClear, btnEvents, br, display]);
}

showText(display, value) {
  // adding new ParagraphElement with the value to the display DIV.
  display.nodes.add(new ParagraphElement()..text=value);
  // Autoscroll for the display DIV.
  var scrollHeight = Math.max(display.scrollHeight, window.innerHeight);
  display.scrollTop = scrollHeight - display.clientHeight;
}
