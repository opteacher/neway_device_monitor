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

String _url = "https://api.neway.cn";
String _getDevicePath = "/api/v1/devices/info/show?deviceId=28";
String _getSensorPath = "/api/v1/devices/sensors";

getDevice() => reqTempFunc(http.get(_url + _getDevicePath));
//getSensor() => reqTempFunc(http.get(_url + _getSensorPath));
getSensor() => Future(() => ResponseInfo(jsonDecode("{\"code\":0,\"message\":\"0\",\"ttl\":1,\"data\":[{\"point_id\":26316957,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"4#\",\"value\":1,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"},{\"point_id\":17671279,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"2#\",\"value\":1,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"},{\"point_id\":25044485,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"3#\",\"value\":0,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"},{\"point_id\":28365978,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"5#\",\"value\":0,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"},{\"point_id\":20625587,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"8#\",\"value\":1,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"},{\"point_id\":10020979,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"1#\",\"value\":0,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"},{\"point_id\":17433258,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"7#\",\"value\":0,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"},{\"point_id\":18958266,\"group_id\":0,\"device_id\":34,\"room_id\":0,\"type\":1,\"name\":\"温度\",\"value\":23.8,\"unit\":\"\",\"time\":\"2019-10-3010:56:32\"},{\"point_id\":29389214,\"group_id\":0,\"device_id\":34,\"room_id\":0,\"type\":1,\"name\":\"湿度\",\"value\":45.7,\"unit\":\"\",\"time\":\"2019-10-3010:56:32\"},{\"point_id\":23331729,\"group_id\":0,\"device_id\":32,\"room_id\":0,\"type\":2,\"name\":\"6#\",\"value\":1,\"unit\":\"\",\"time\":\"2019-10-3010:56:37\"}]}")["data"], "请求成功！"));