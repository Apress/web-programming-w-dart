import 'dart:io';
import 'dart:convert';

void handlePost(HttpRequest request) {
  ContentType contentType = request.headers.contentType;
  BytesBuilder builder = new BytesBuilder();
  request.listen((buffer) {
    builder.add(buffer);
  }, onDone: () {
   // write to a file, get the file name from the URI
   String jsonString = UTF8.decode(builder.takeBytes());
   Map data = Uri.splitQueryString(jsonString);
   request.response.headers.add('Access-Control-Allow-Origin', '*');
   request.response.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
   request.response.headers.add('Access-Control-Allow-Headers',
       'Origin, X-Requested-With, Content-Type, Accept');
   request.response.statusCode = HttpStatus.OK;
   request.response.write(data);
   request.response.close();
  });
}

void handleGet(HttpRequest request) {
  switch (request.uri.path) {
    case '/':
      request.response.statusCode = HttpStatus.OK;
      request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
      request.response.write('<h1>Index of chapter_27/web/</h1><ul>');
      new Directory('.').listSync().forEach((FileSystemEntity entity) {
        var df = entity.path.split('./').last;
        request.response.write('<li><a href="./${df}">${df}</a></li>');
      });
      request.response.write('</ul>');
      request.response.close();
      break;

    default:
      final String path = request.uri.toFilePath();
      final File file = new File('./$path');
      file.exists().then((bool found) {
        if (found) {
          request.response.statusCode = HttpStatus.OK;
          request.response.write(file.readAsStringSync());
        } else {
          request.response.statusCode = HttpStatus.NOT_FOUND;
          request.response.write('not found');
        }
        request.response.close();
      });
      break;
  }
}


void main() {
 HttpServer.bind('127.0.0.1', 8088)
 .then((server) {
   print("Server running on http://127.0.0.1:8088/");
   server.listen((HttpRequest request) {
     switch(request.method) {
       case 'POST':
         handlePost(request);
         break;

       case 'GET':
       default:
         handleGet(request);
         break;
     }
   });
 })
 .catchError((e) => print('Error :: $e'));
}
