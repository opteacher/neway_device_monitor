import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
	SystemChrome.setPreferredOrientations([
		DeviceOrientation.landscapeLeft,
		DeviceOrientation.landscapeLeft
	]);
	SystemChrome.setEnabledSystemUIOverlays([]);
	return runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) => MaterialApp(
		theme: ThemeData(
			accentColor: Color(0xff616161)
		),
		home: MyHomePage(),
	);
}

class MyHomePage extends StatefulWidget {
	@override
	_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	TextStyle _infoTxtStyle;

	int _id = 10032;
	String _name = "乐维机组1#";
	String _brand = "Cummins";
	String _prodDate = "2014/03/27";
	String _location = "虹口区邯郸路173号";
	int _power = 1200;
	int _fullFuelHR = 180;
	int _leftFuel = 100;
	int _recycle = 2;
	int _mtcycle = 1;
	int _svcTime = 288;
	int _noFaultTime = 365;
	double _antifreezeTemp = -16;
	double _batResistance = 1.62;
	double _batLoadFactor = 68;
	List<Map<String, String>> _svcRecords = [{
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}];

	Widget _genElecIndicator(String title, int ttlColor, double ttlHpdg, Widget content) {
		return Expanded(child: Card(child: Column(children: <Widget>[
			Container(
				decoration: BoxDecoration(
					color: Color(ttlColor),
					borderRadius: BorderRadius.vertical(top: Radius.circular(4))
				),
				padding: EdgeInsets.symmetric(vertical: 10, horizontal: ttlHpdg),
				child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20))
			),
			Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), child: content)
		])));
	}

	Widget _genRecordTable() {
		List<TableRow> children = [
			TableRow(children: [
				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(child: Text("时间"))),
				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(child: Text("事项"))),
				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(child: Text("报告编号"))),
			])
		];
		children.addAll(_svcRecords.map<TableRow>((rcd) => TableRow(children: [
			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(child: Text(rcd["time"]))),
			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(child: Text(rcd["event"]))),
			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(child: Text(rcd["id"]))),
		])));
		return Container(decoration: BoxDecoration(
			border: Border.all(color: Colors.grey[300])
		), child: Table(
			columnWidths: {
				0: FractionColumnWidth(0.25),
				1: FractionColumnWidth(0.5),
				2: FractionColumnWidth(0.25),
			},
			border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey[300])),
			defaultVerticalAlignment: TableCellVerticalAlignment.middle,
			children: children
		));
	}

	@override
	Widget build(BuildContext context) {
		_infoTxtStyle = TextStyle(color: Color(0xffB4B4B4), fontSize: 20);

		return Scaffold(
			body: Padding(padding: EdgeInsets.all(10), child: Column(children: <Widget>[
				Expanded(child: Row(children: <Widget>[
					Expanded(flex: 2, child: Container(
						margin: EdgeInsets.only(right: 20),
						child: Image.asset("images/background.png")
					)),
					Expanded(child: Column(children: <Widget>[
						Container(
							decoration: BoxDecoration(
								color: Color(0xffe6fafa),
								border: Border.all(color: Color(0xffB4B4B4)),
								borderRadius: BorderRadius.all(Radius.circular(10))
							),
							margin: EdgeInsets.only(bottom: 5),
							child: Row(children: <Widget>[
								Container(
									decoration: BoxDecoration(
										color: Color(0xff62c4ac),
										borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
									),
									padding: EdgeInsets.symmetric(horizontal: 10, vertical: 35),
									child: Text("机\n组\n信\n息", style: TextStyle(
										color: Colors.white,
										fontSize: 25
									))
								),
								Padding(padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10), child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										Text("乐维编号：$_id", style: _infoTxtStyle),
										Text("名称：$_name", style: _infoTxtStyle),
										Text("品牌：$_brand", style: _infoTxtStyle),
										Text("生产日期：$_prodDate", style: _infoTxtStyle),
										Text("位置：$_location", style: _infoTxtStyle),
										Text("功率：${_power}KW", style: _infoTxtStyle),
									]
								))
							])
						),
						Container(
							decoration: BoxDecoration(
								color: Color(0xffe6fafa),
								border: Border.all(color: Color(0xffB4B4B4)),
								borderRadius: BorderRadius.all(Radius.circular(10))
							),
							margin: EdgeInsets.only(top: 5),
							child: Row(children: <Widget>[
								Container(
									decoration: BoxDecoration(
										color: Color(0xff77C0F4),
										borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
									),
									padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
									child: Text("参\n考\n信\n息", style: TextStyle(
										color: Colors.white,
										fontSize: 25
									))
								),
								Padding(padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10), child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										Text("满载耗油：${_fullFuelHR}L/h", style: _infoTxtStyle),
										Text("剩余燃油：${_leftFuel}L", style: _infoTxtStyle),
										Text("蓄电池更换周期：$_recycle年", style: _infoTxtStyle),
										Text("机组保养周期：$_mtcycle年", style: _infoTxtStyle)
									]
								))
							])
						)
					])),
				])),
				Expanded(child: Container(
					decoration: BoxDecoration(
						border: Border.all(color: Color(0xffB4B4B4)),
						borderRadius: BorderRadius.all(Radius.circular(10))
					),
					padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
					child: Row(children: <Widget>[
						Expanded(child: Column(children: <Widget>[
							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
								Text("发电机相关指标", style: TextStyle(color: Color(0xff616161), fontSize: 25))
							]),
							Divider(color: Color(0xffF8A72C), endIndent: 180),
							Column(children: <Widget>[
								Row(children: <Widget>[
									_genElecIndicator("乐维服务时长", 0xffF8A72C, 30, Row(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											Text(_svcTime.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 35)),
											Text("天", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										]
									)),
									_genElecIndicator("平均无故障时间", 0xff62C4AC, 20, Row(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											Text(_noFaultTime.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 35)),
											Text("天", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										]
									))
								]),
								Row(children: <Widget>[
									_genElecIndicator("防冻液", 0xff77C0F4, 60, Row(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											Text(_antifreezeTemp.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 35)),
											Text("℃", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										]
									)),
									_genElecIndicator("蓄电池", 0xffC46262, 60, Column(children: <Widget>[
										Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
											Text("${_batResistance}mΩ", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										]),
										Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
											Text("${_batLoadFactor}%", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										])
									]))
								])
							])
						])),
						VerticalDivider(width: 40),
						Expanded(child: Column(children: <Widget>[
							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
								Text("服务记录", style: TextStyle(color: Color(0xff616161), fontSize: 25))
							]),
							Divider(color: Color(0xffF8A72C), endIndent: 250),
							_genRecordTable()
						])),
						VerticalDivider(width: 40),
						Expanded(child: Column(children: <Widget>[
							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
								Text("温馨提示", style: TextStyle(color: Color(0xff616161), fontSize: 25))
							]),
							Divider(color: Color(0xffF8A72C), endIndent: 250),
							Text("1.机组建议使用复合标准的防冻液，严禁使用自来水\n"
								"2.建议发电机组不能再低于30%负荷下长时间进行\n"
								"3.建议定期启动发电机组，运行10-15分钟，检查机组运行状况\n"
								"4.机组需映入市电，为电池浮充及加热器提供电源\n"
								"5.冬季建议开启加热器", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 18)),
							Container(
								margin: EdgeInsets.only(top: 20),
								decoration: BoxDecoration(
									gradient: LinearGradient(colors: [
										Color(0xffF9F9F9),
										Color(0xffD1D1D1)
									], begin: Alignment.topCenter, end: Alignment.bottomCenter)
								),
								child: Column(children: <Widget>[
									Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
										Icon(Icons.label, color: Color(0xffC46262))
									]),
									Padding(
										padding: EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 3),
										child: Text("近期天气炎热，机组加热器可以关闭", style: TextStyle(fontSize: 20, color: Color(0xff616161)))
									)
								])
							)
						]))
					])
				))
			]))
		);
	}
}
