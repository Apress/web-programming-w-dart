import 'dart:html';

void main() {

 var p = document.querySelector('#sample_text_id')
     ..classes.add('message')
     ..text = 'Welcome to Dart !';

 var btn1 = new ButtonElement()
   ..id = 'show'
   ..text = 'Show'
   ..onClick.listen((e) {
     p.classes.retainWhere((c) => c=='message');
     p.classes.add('fade-in');
   });

 var btn2 = new ButtonElement()
   ..id = 'hide'
   ..text = 'Hide'
   ..onClick.listen((e) {
     p.classes.retainWhere((c) => c=='message');
     p.classes.add('fade-out');
   });

 document.body.nodes.addAll([btn1, btn2]);
}
