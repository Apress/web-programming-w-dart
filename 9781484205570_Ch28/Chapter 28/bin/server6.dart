import 'dart:io';

void main() {
  HttpServer.bind('127.0.0.1', 8080)
  .then((server) {
  server.listen((HttpRequest request) {
    // Handle server requests.
    switch(request.uri.path) {
      case '/ps':
        request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
        request.response.write('''
         <html>
           <head><title>System processes</title></head>
           <body>
           <h2>System processes</h2>
        ''');
        var proc = Process.runSync('ps', [], runInShell:true);
        request.response.write('<pre>');
        if(proc.exitCode == 0) {
          request.response.write(proc.stdout);
        } else {
          request.response.write(proc.stderr);
        }
        request.response.write('</pre>');
        request.response.write('</body></hmtl>');
        request.response.close();
        break;

      default:
        var path = 'web${request.uri.path}';
        switch(FileStat.statSync(path).type) {
          case FileSystemEntityType.DIRECTORY:
            request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
            request.response.write('<h1>Index of /web${request.uri.path}</h1><ul>');
            var dir = new Directory(path);
            if (request.uri.path != '/') {
              request.response.write('<li><a href="/">..</a></li>');
            }
            dir.listSync().forEach((FileSystemEntity entity) {
              var df = entity.path.split(path).last;
              request.response.write('''
                <li><a href="${request.uri.path}${df}">${df}</a></li>
              ''');
            });
            request.response.write('</ul>');
            request.response.close();
            break;

          case FileSystemEntityType.FILE:
            var fich = new File(path);
            if(request.uri.path.endsWith('html')) {
              request.response.headers.add(HttpHeaders.CONTENT_TYPE, 'text/html');
            }
            request.response.write(fich.readAsStringSync());
            request.response.close();
            break;

          case FileSystemEntityType.NOT_FOUND:
            request.response.write('Not found');
            request.response.close();
            break;
        }
      }
    });
  })
  .catchError((e) => print('Error :: $e'));
}
