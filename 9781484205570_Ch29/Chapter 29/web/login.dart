import 'package:polymer/polymer.dart';

/**
 * A Polymer login user system.
 */
@CustomTag('login-user')
class LoginUser extends PolymerElement {
  @observable String user;
  @observable String password;
  @observable bool error = false;
  @observable String login_error = '';

  LoginUser.created() : super.created();

  /// Validates user name and password.
  void login() {
    if(user == null || user.trim() == '' ||
        password == null || password.trim() == '') {
      error = true;
      login_error = 'Please type user and password.';
      return;
    }
  }
  
  /// To remember the forgotten password.
  void rememberPassword() {}
  
  /// To login with Facebook.
  void facebookLogin() {}
  
  /// To login with Twitter.
  void twitterLogin() {}

}

