import 'dart:io';

void main() {
 HttpServer.bind('127.0.0.1', 8080)
 .then((server) {
   server.listen((HttpRequest request) {
     // Handle server requests.
     switch (request.uri.path) {
       default:
         var path = 'web${request.uri.path}';
         request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
         request.response.write('<h1>Index of /$path</h1><ul>');
         if(FileStat.statSync(path).type == FileSystemEntityType.DIRECTORY) {

           var dir = new Directory(path);
           if (request.uri.path != '/') {
             request.response.write('<li><a href="/">..</a></li>');
           }
           dir.listSync().forEach((FileSystemEntity entity) {
             var df = entity.path.split(path).last;
             request.response.write('<li><a href="${df}">${df}</a></li>');
           });
         }
         request.response.write('</ul>');
         request.response.close();
     }
   });
 })
 .catchError((e) => print('Error :: $e'));
}