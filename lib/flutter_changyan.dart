library flutter_changyan;

import 'dart:io';
import 'dart:convert';

class FlutterChangyan {
  static String _clientId;
  static String _clientSecret;
  static String _callBackUrl;
  static String _accessToken = '';
  static String _api = 'changyan.sohu.com';
  static HttpClient _client = new HttpClient();


// visit http://changyan.kuaizhan.com/overview get clientId and clientSecret
// visit http://changyan.kuaizhan.com/setting/common/further set callbackUrl
  static register(String clientId, String clientSecret, String callbackUrl, [String accessToken]) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _callBackUrl = callbackUrl;
    if (accessToken != null) {
      _accessToken = accessToken;
    }
  }

// you need to call info() get topicId first, then use topicId call moreComments
  static moreComments(num page, num topicId) async {
    var uri = Uri.https(
      _api,
      '/api/2/topic/comments',
      {
        'client_id': _clientId,
        'topic_id': topicId.toString(),
        'page_no': page.toString()
      }
    );
    var res = await _request(uri);
    return res['comments'];
  }

// include first page comments, comments count, pagination...
  static info(num sourceId) async {
    var uri = Uri.https(_api, '/api/2/topic/load', {
      'client_id': _clientId,
      'topic_url': '',
      'topic_source_id': sourceId.toString()
    });
    return await _request(uri);
  }

  static batchCount(List<num> sourceIds) async {
    var uri = Uri.https(_api, '/api/2/topic/count', {
      'client_id': _clientId,
      'topic_source_id': sourceIds.join(',')
    });
    var res = Map();
    var data = await _request(uri);
    res = data['result'];
    return res;
  }

  static post(num topicId, String content, [num commentId]) async {
    var data = {
      'client_id': _clientId,
      'topic_id': topicId.toString(),
      'content': content,
      'access_token': _accessToken
    };
    if (commentId != null) {
      data['reply_id'] = commentId.toString();
    }
    var uri = Uri.https(_api, '/api/2/comment/submit', data);
    return await _request(uri, 'post');
  }

  // 0: default, 1: weibo, 2: qq, 11 Sohu
  static loginUrl([String platform]) {
    var data = {
      'client_id': _clientId,
      'redirect_uri': _callBackUrl,
      'response_type': 'code'
    };
    if (platform != '') {
      data['platform'] = platform;
    }
    var uri = Uri.https(_api, '/api/oauth2/authorize', data);
    return uri.toString();
  }

  static login(String code) async {
    var uri = Uri.https(_api, '/api/oauth2/token', {
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'grant_type': 'authorization_code',
      'redirect_uri': _callBackUrl,
      'code': code
    });
    var data = await _request(uri, 'post');
    if (data['access_token'] != null) {
      _accessToken = data['access_token'];
      return _accessToken;
    }
    throw new Exception('unexpected login response');
  }

  static userInfo() async {
    var uri = Uri.https(_api, '/api/2/user/info', {
      'client_id': _clientId,
      'access_token': _accessToken
    });
    var res = await _request(uri);
    return res;
  }

  static _request(Uri uri, [String method]) async {
    if (method == null) {
      method = 'get';
    }
    var req = await _client.openUrl(method, uri);
    var resp = await req.close();
    var respBody = await resp.transform(utf8.decoder).join();
    var data = Map();
    data = await json.decode(respBody);
    if (data.containsKey('error_msg')) {
      throw new Exception(data['error_msg']);
    }
    return data;
  }
}
