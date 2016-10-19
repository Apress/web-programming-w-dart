import 'dart:io';
import 'dart:convert';

void main() {
 HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080)
 .then((server) {
   print("Server running on http://${InternetAddress.LOOPBACK_IP_V4.address}:8080/");
   server.listen((HttpRequest request) {
     switch(request.method) {
       case 'POST':
         handlePost(request);
         break;

       case 'GET':
         handleGet(request);
         break;

       default:
         request.response
          ..statusCode = HttpStatus.NOT_IMPLEMENTED
          ..write('Unsupported method')
          ..close();
         break;
     }
   });
 })
 .catchError((e) => print('Error :: $e'));
}

void handleGet(HttpRequest request) {
  var path = 'web${request.uri.path}';
  print(path);
  print(FileStat.statSync(path).type);
  switch(FileStat.statSync(path).type) {

    case FileSystemEntityType.DIRECTORY:
      handleDir(path, request);
      break;

    case FileSystemEntityType.FILE:
    default:
      handleFile(path, request);
      break;
  }
}

void handleDir(String path, HttpRequest request) {
  request.response.statusCode = HttpStatus.OK;
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
  request.response.statusCode = HttpStatus.OK;
  if(request.uri.path.endsWith('html')) {
    request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
  }
  var file = new File(path);
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
}

void handlePost(HttpRequest request) {
  ContentType contentType = request.headers.contentType;
  BytesBuilder builder = new BytesBuilder();
  request.listen((buffer) {
    builder.add(buffer);
  }, onDone: () {
   String bodyString = UTF8.decode(builder.takeBytes());
   Map data = Uri.splitQueryString(bodyString);
   request.response.headers.add('Access-Control-Allow-Origin', '*');
   request.response.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
   request.response.headers.add('Access-Control-Allow-Headers',
       'Origin, X-Requested-With, Content-Type, Accept');
   request.response.statusCode = HttpStatus.OK;
   request.response.write(data);
   request.response.close();
  });
}