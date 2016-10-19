import 'dart:html';

void request(String asset) {
  var response = document.querySelector('#response');
  var url = 'http://localhost:8080/${asset}';
  HttpRequest.getString(
    url,
    onProgress:(_) => response.text = 'Loading ...')
    .then((resp) => response.setInnerHtml('<pre>${resp}</pre>'))
    .catchError((error) => response.text = 'ERROR !!!: ${error.toString()}');
}

void main() {
  var buttons = document.querySelector('#buttons');

  var btn1 = new ButtonElement()
    ..id = 'btn1'
    ..text = 'Get CSS code'
    ..onClick.listen((_) => request('chapter_27.css'));

  var btn2 = new ButtonElement()
      ..id = 'btn2'
      ..text = 'Get Dart code'
      ..onClick.listen((_) => request('chapter_27.dart'));

  var btn3 = new ButtonElement()
        ..id = 'btn3'
        ..text = 'Get User info'
        ..onClick.listen((_) => request('user_data.txt'));

  buttons.nodes.addAll([btn1, btn2, btn3]);
}
