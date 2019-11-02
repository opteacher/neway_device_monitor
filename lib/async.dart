import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ResponseInfo {
	final dynamic _data;
	final String _message;

	ResponseInfo(this._data, this._message);

	String get message => _message;
	dynamic get data => _data;
}

Future<ResponseInfo> reqTempFunc(Future<http.Response> requester) async {
	String message;
	try {
		var resp = await requester;
		if (resp.statusCode == HttpStatus.ok) {
			Map respBody = jsonDecode(resp.body);
			if(respBody["code"] != 100401
				&& respBody["code"] != 100402
				&& respBody["code"] != 100301
				&& respBody["code"] != 0) {
				message = respBody["message"];
			} else {
				message = "请求成功！";
				return Future(() => ResponseInfo(
					respBody["data"], message
				));
			}
		} else {
			message = "后台发生错误，错误码：${resp.statusCode}";
		}
	} catch (e) {
		message = "网络发生错误：${e.toString()}";
	}
	return Future(() => ResponseInfo(null, message));
}

String _url = "http://10.168.1.100:8080";
String _getDevicePath = "/api/v1/devices/info/show";
String _getSensorPath = "/api/v1/devices/sensors";
String _getWarningPath = "/api/v1/alarm/list";

getDevice() => reqTempFunc(http.get(_url + _getDevicePath));
getSensor() => reqTempFunc(http.get(_url + _getSensorPath));
getWarning() => reqTempFunc(http.get(_url + _getWarningPath));