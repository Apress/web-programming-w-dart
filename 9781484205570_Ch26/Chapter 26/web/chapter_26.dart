import 'dart:html';

void main() {

var container = document.querySelector('#sample_container_id');
var p = document.querySelector('#sample_text_id');

var addClass = (String cls, String msg) => (event) {
  container.classes
    ..clear()
    ..add(cls);
  p.text = msg;
};

var btn1 = new ButtonElement()
 ..id = 'btn1'
 ..text = ' ERROR '
 ..onClick.listen(addClass('error','This is an error message !'));

var btn2 = new ButtonElement()
 ..id = 'btn2'
 ..text = 'ALERT'
 ..onClick.listen((event) {
   container.classes
     ..clear()
     ..add('warning');
   p.text = 'This is an alert message !';
 });

var btn3 = new ButtonElement()
 ..id = 'btn3'
 ..text = 'OK'
 ..onClick.listen((event) {
   container.classes
     ..clear()
     ..add('success');
   p.text = 'This is an OK message';
 });
document.body.nodes.addAll([btn1, btn2, btn3]);

var btn4 = new ButtonElement()
 ..id = 'btn4'
 ..text = 'Toggle'
 ..onClick.listen((event) {
   container.classes.toggle('toggle');
   p.text = ' Toggle !';
 });
document.body.nodes.add(btn4);


}
