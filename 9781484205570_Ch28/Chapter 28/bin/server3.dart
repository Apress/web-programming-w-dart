import 'dart:io';

void handleDir(String path, HttpRequest request) {
  request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
  request.response.write('<h1>Index of /$path</h1><ul>');
  var dir = new Directory(path);
  if (request.uri.path != '/') {
    request.response.write('<li><a href="/">..</a></li>');
  }
  dir.listSync().forEach((FileSystemEntity entity) {
    var df = entity.path.split(path).last;
    request.response.write('''<li><a href="${request.uri.path}${df}">
                        ${df}</a></li>''');
  });
  request.response.write('</ul>');
  request.response.close();
}

void handleFile(String path, HttpRequest request) {
  var fich = new File(path);
  request.response.write(fich.readAsStringSync());
  request.response.close();
}

void main() {
 HttpServer.bind('127.0.0.1', 8080)
 .then((server) {
   server.listen((HttpRequest request) {
     // Handle server requests.
     var path = 'web${request.uri.path}';
     switch(FileStat.statSync(path).type) {

       case FileSystemEntityType.DIRECTORY:
         handleDir(path, request);
         break;

       case FileSystemEntityType.FILE:
         handleFile(path, request);
         break;
     }
   });
 })
 .catchError((e) => print('Error :: $e'));
}