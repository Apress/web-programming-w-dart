import 'dart:html';
import 'dart:async';
import 'dart:isolate';

main() {
 Element myresult = querySelector('#sample_text_id');

 // Define send/reply ports.
 SendPort sendPort;
 ReceivePort receivePort = new ReceivePort();
 receivePort.listen((msg) {
   if (sendPort == null) {
     sendPort = msg;
   } else {

     switch(msg) {
       case "FROM PROCESS: START":
         myresult.appendHtml(' Running costly process....<br/><br/>');
         break;

       case "FROM PROCESS: END":
         myresult.appendHtml(' Costly process completed successfully<br/><br/>');
         receivePort.close();
         break;

       default:
         myresult.appendHtml(' Received from the isolate: $msg<br/><br/>');
     }
   }
 });

 // This is a costly process that we want to execute.
 String Costlyprocess = 'costly_process.dart';
 int counter = 0;
 var timer;
 Isolate.spawnUri(Uri.parse(Costlyprocess), [], receivePort.sendPort).then((isolate) {
   print('Isolate running !!');
   timer = new Timer.periodic(const Duration(seconds: 1), (t) {

     switch (counter) {
       case 0:
         sendPort.send("START");
         break;

       case 5:
         sendPort.send("END");
         timer.cancel();
         break;

       default:
         // Every second we send a message to the costly process.
         sendPort.send('From application: ${counter}');
     }
     counter += 1;

   });
 });

 // We can continue executing more code while waiting for the
 // reply execution of our process in background.
 print('Continue executing more instructions');
 print('.....');
 print('Application completed');
}
