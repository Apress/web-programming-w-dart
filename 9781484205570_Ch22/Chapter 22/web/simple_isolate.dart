import 'dart:async';
import 'dart:isolate';

void CostlyProcess(SendPort replyTo) {
  var port = new ReceivePort();
  replyTo.send(port.sendPort);
  port.listen((msg) {
    var data = msg[0];
    replyTo = msg[1];
    if (data == "START") {
      replyTo.send("Running costly process....");
      // Costly stuff here
      replyTo.send("END");
      port.close();
    }
  });
}

void main() {
  // Start application
  print('Start application');

  // Create the reply port for the isolate.
  var reply = new ReceivePort();

  // We’ll run the costly process in an Isolate.
  Future<Isolate> iso = Isolate.spawn(CostlyProcess, reply.sendPort);
  iso.then((_) => reply.first).then((port) {

    // Once I’ve created the Isolate, I send the start message process and
    // I'm waiting to receive a reply from the big  process to execute.
    reply = new ReceivePort();
    port.send(["START", reply.sendPort]);
    reply.listen((msg) {
      print('Message received from isolate: $msg');
      if (msg == "END") {
        print('Costly process completed successfully !!!');
        reply.close();
      }
    });

  });

  // We can continue running more code while waiting for the
  // execution reply of our costly process in background.
  print ('Continue running instructions');
}
