import 'dart:html';
import 'dart:async';

void main() {
 var msg = document.querySelector('#messages');
 var timer = new Timer.periodic(new Duration(seconds: 1), (_){
   msg.classes.toggle('enlarge');
 });
}
