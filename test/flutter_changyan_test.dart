import 'package:test/test.dart';
import 'package:flutter_changyan/flutter_changyan.dart';

// visit http://changyan.kuaizhan.com/overview get clientId and clientSecret
const clientId = 'your client id';
const clientSecret = 'your client secret';
// visit http://changyan.kuaizhan.com/setting/common/further set callbackUrl
const callbackUrl = 'your callback url';
var token = '';
var code = '';

void main() {
  test('batch count', () async {
    FlutterChangyan.register(clientId, clientSecret, callbackUrl);
    var cnt = await FlutterChangyan.batchCount([3]);
    print('batch count: $cnt');
  });
  test('info', () async {
    FlutterChangyan.register(clientId, clientSecret, callbackUrl);
    var info = await FlutterChangyan.info(3);
    print('info: $info');
    var comments = await FlutterChangyan.moreComments(2, info['topic_id']);
    print('more comments: $comments');
  });

  test('login url', () {
    FlutterChangyan.register(clientId, clientSecret, callbackUrl);
    var loginUrl = FlutterChangyan.loginUrl();
    print('loginUrl: $loginUrl');
  });

  test('login', () async {
    FlutterChangyan.register(clientId, clientSecret, callbackUrl);
    var loginInfo = await FlutterChangyan.login(code);
    print('login info: $loginInfo');
  });

  test('post', () async {
    FlutterChangyan.register(clientId, clientSecret, callbackUrl, token);
    var res = await FlutterChangyan.post(1024, "this is a comment");
    print('post res: $res');
  });

  test('user info', () async {
    FlutterChangyan.register(clientId, clientSecret, callbackUrl, token);
    var res = await FlutterChangyan.userInfo();
    print('user info: $res');
  });
}
