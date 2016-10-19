import 'dart:html';
import 'dart:convert';

void main() {

  Map data = {
    'user': 'moisesbelchin@gmail.com',
    'name': 'Moises Belchin',
    'access': '2014-10-29 17:22'
  };

  var url = 'http://127.0.0.1:8088';
  var xhr = new HttpRequest();
  xhr
  ..open('POST', url)
  ..setRequestHeader('Content-Type', 'application/json')
  ..send(JSON.encode(data));

  xhr = HttpRequest.request(url,
      method:'POST',
      requestHeaders:{
        'Content-Type': 'application/json'
      },
      sendData: JSON.encode(data)
  )
  .then((v) => print(v))
  .catchError((error) => print(error));

}
