import 'dart:io';

void main() {
 HttpServer.bind('127.0.0.1', 8080)
 .then((server) {
   server.listen((HttpRequest request) {
     // Handle server requests.
     switch (request.uri.path) {
       case '/':
       default:
         request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
         request.response.write('<h1>Index of /web/</h1><ul>');
         new Directory('web/').listSync().forEach((FileSystemEntity entity) {
           var df = entity.path.split('web/').last;
           request.response.write('<li><a href="web/${df}">${df}</a></li>');
         });
         request.response.write('</ul>');
         request.response.close();
     }
   });
 })
 .catchError((e) => print('Error :: $e'));
}