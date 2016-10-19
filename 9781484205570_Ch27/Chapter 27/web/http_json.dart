import 'dart:html';
import 'dart:convert' show JSON;

void listCustomers(HttpRequest xhr) {
 var div_resp = document.querySelector('#response');
 StringBuffer tpl = new StringBuffer('''<table border="1">
   <tr>
     <th colspan="3"></th>
     <th colspan="5"> Address </th>
   <tr>
     <th>ID</th>
     <th>Name</th>
     <th>Surname</th>
     <th>Street</th>
     <th>Number</th>
     <th>ZipCode</th>
     <th>State</th>
     <th>Country</th>
   </tr>''');
 Map d = JSON.decode(xhr.responseText);
 d['customers'].forEach((c) {
   tpl.write('''
   <tr>
     <td>${c['id']}</td>
     <td>${c['name']}</td>
     <td>${c['surname']}</td>
     <td>${c['address']['street']}</td>
     <td>${c['address']['number']}</td>
     <td>${c['address']['zip']}</td>
     <td>${c['address']['state']}</td>
     <td>${c['address']['country']}</td>
   </tr>''');
 });
 tpl.write('</table>');
 div_resp.setInnerHtml(tpl.toString());
}

void error(e) {
 var div_resp = document.querySelector('#response');
 div_resp.setInnerHtml('Error launching request: $e');
}

void loading() {
 var div_resp = document.querySelector('#response');
 div_resp.setInnerHtml('Loading...');
}

void getCustomers() {
 var url = 'http://localhost:8080/customers.json';
 var xhr = new HttpRequest();
 xhr
 ..onLoad.listen((e) {
   if ((xhr.status >= 200 && xhr.status < 300) ||
        xhr.status == 0 || xhr.status == 304) {
     listCustomers(xhr);
   } else {
     error(xhr.status);
   }
 })
 ..onError.listen((e) => error(e))
 ..onProgress.listen((_) => loading())
 ..open('GET', url)
 ..send();
}

void main() {
  var buttons = document.querySelector('#buttons');
  var btn1 = new ButtonElement()
    ..id = 'btn1'
    ..text = 'Get customers'
    ..onClick.listen((e) => getCustomers());
  buttons.nodes.add(btn1);
}
