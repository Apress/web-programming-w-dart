import 'dart:html';

void main() {
  var libs = document.querySelector('#libraries');
  var libs_list = libs.querySelector('ul');
  libs_list.classes.add('hide');
  libs.onClick.listen((e) {
    var arrow = libs.querySelector('h2 div');
    arrow.classes.toggleAll(['arrow-right', 'arrow-down']);
    libs_list.classes.toggle('hide');
  });
  
  var events = document.querySelector('#events');
  var events_list = events.querySelector('ul');
  events_list.classes.add('hide');
  events.onClick.listen((e) {
    var arrow = events.querySelector('h2 div');
    arrow.classes.toggleAll(['arrow-right', 'arrow-down']);
    events_list.classes.toggle('hide');
  });
}
