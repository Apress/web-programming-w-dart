import 'dart:html';

void main() {
  var url = 'http://localhost:8080/user_data.txt';
  HttpRequest.request(url, method: 'GET')
  .then((HttpRequest resp) {
    document.querySelector('#response').appendHtml(resp.responseText);
  })
  .catchError((error) => print(error));
}
