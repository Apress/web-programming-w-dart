import 'dart:html';

void response(r) {
 var div_resp = document.querySelector('#response');
 var resp = r.responseText;
 resp = resp.replaceAll('{', '')
   .replaceAll('}', '')
   .replaceAll("['", "")
   .replaceAll("']", "")
   .replaceAll("'", "")
   .split(",").join('<br/>');
 div_resp.setInnerHtml('<b>Status:</b> ${r.status} <br/>'
                       '<b>Response:</b> <br/> ${resp}');
}


void sendMessage() {
 var resp = document.querySelector('#response');
 Map data = new Map();
 data['name'] = (document.querySelector('#name') as InputElement).value.trim();
 data['email'] = (document.querySelector('#email') as InputElement).value.trim();
 data['subject'] = (document.querySelector('#subject') as InputElement).value.trim();
 data['message'] = (document.querySelector('#message') as TextAreaElement).value.trim();

 var url = 'http://127.0.0.1:8088';
 var xhr = HttpRequest.postFormData(url, data,
   onProgress: (_) => resp.text = 'Sending ... ')
   ..then((r) => response(r))
   ..catchError((error) => resp.text = 'ERROR !: ${error.toString()}');
}


void form() {
 var resp = document.querySelector('#form');
 var name = new InputElement()
   ..id = 'name'
   ..size = 45
   ..placeholder = 'Insert your name';
 var email = new EmailInputElement()
   ..id = 'email'
   ..size = 45
   ..placeholder = 'Insert your email';
 var subject = new TextInputElement()
   ..id = 'subject'
   ..size = 45
   ..placeholder = 'What is the reason for your message?';
 var message = new TextAreaElement()
   ..id = 'message'
   ..cols = 40
   ..rows = 10
   ..placeholder = 'How we can help you?';
 var send = new ButtonElement()
   ..id = 'send'
   ..text = ' Send message ! '
   ..onClick.listen((e) => sendMessage());

 resp.nodes.clear();
 resp.nodes.addAll([name, new BRElement(),
                    email, new BRElement(),
                    subject, new BRElement(),
                    message, new BRElement(),
                    send]);
 name.focus();
}

void main() {
 var buttons = document.querySelector('#buttons');
 var btn1 = new ButtonElement()
   ..id = 'btn1'
   ..text = 'Contact'
   ..onClick.listen((e) => form());
 buttons.nodes.add(btn1);
}
