# flutter_changyan

changyan flutter package.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).

## Example

```dart
// open webview login changyan
FlutterChangyan.register('your clientId', 'your clientSecret', 'https://yourdomain.com');
    var loginUrl = FlutterChangyan.loginUrl();
    Navigator.push(context, new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new WebviewScaffold(
          url: loginUrl,
          appBar: new AppBar(
            title: const Text('登录畅言'),
          ),
          withZoom: true,
          withLocalStorage: true,
        );
      },
    ));

// subscribe url changed event get authorization code
_onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
  var _uri = Uri.parse(url);
  if (_uri.host == 'yourdomain.com' &&
      _uri.queryParameters['code'] != null) {
    print('code is ${_uri.queryParameters['code']}');
    print('try to close window');
    Navigator.of(context).pop();
    FlutterChangyan.login(_uri.queryParameters['code']).then((accessToken) {
      print('login success: $accessToken');
    });
  }
});

// then post your comment, replace your topicId
var data = await FlutterChangyan.post(1024, '大哥闻是最棒的 via flutter');
print('post comment result $data');
```